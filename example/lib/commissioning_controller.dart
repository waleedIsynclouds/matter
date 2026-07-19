import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_matter/flutter_matter.dart';
import 'package:flutter_matter_example/ble_manager.dart';
import 'package:flutter_matter_example/data.dart';
import 'package:hex/hex.dart';
import 'package:pointycastle/export.dart';

enum ProvisioningTransport { androidBle, onNetwork }

enum SubStepStatus { pending, active, done, error }

enum CommissioningPhase {
  bleScanConnect,
  controllerSetup,
  secureSession,
  readCommissioningInfo,
  deviceAttestation,
  nocChainGeneration,
  networkProvisioning,
  complete,
}

class CommissioningSubStep {
  final CommissioningPhase phase;
  final String label;
  SubStepStatus status;
  String? detail;

  CommissioningSubStep({
    required this.phase,
    required this.label,
    this.status = SubStepStatus.pending,
    this.detail,
  });
}

class CommissioningController
    implements
        NOCChainIssuer,
        BlePlatformDelegate,
        CompletionListener,
        DeviceAttestationDelegate {
  final OnboardingPayload payload;
  final String rawCode;
  final WiFiCredentials wifiCredentials;
  final ProvisioningTransport transport;

  BLEManager? bleManager;
  int? connectId;
  int? nodeId;
  int? fabricId;
  ChipDeviceController? deviceController;
  late AsymmetricKeyPair<ECPublicKey, ECPrivateKey> keypair;
  late List<Uint8List> cert;

  final List<CommissioningSubStep> subSteps;
  final List<String> log = [];
  void Function()? onChanged;
  void Function(bool success, int errorCode)? onFinished;

  bool _started = false;
  bool _finished = false;
  bool _cleanedUp = false;

  CommissioningController({
    required this.payload,
    required this.rawCode,
    required this.wifiCredentials,
    required this.transport,
  }) : subSteps = _buildSubSteps(payload, transport);

  bool get isFinished => _finished;

  bool get shouldUseAndroidBle =>
      transport == ProvisioningTransport.androidBle &&
      Platform.isAndroid &&
      !_isShareCode(payload);

  CommissioningPhase get _activePhase =>
      _firstWhereOrNull(
        subSteps,
        (step) => step.status == SubStepStatus.active,
      )?.phase ??
      _firstWhereOrNull(
        subSteps,
        (step) => step.status == SubStepStatus.pending,
      )?.phase ??
      CommissioningPhase.complete;

  static bool _isShareCode(OnboardingPayload payload) {
    return payload.vendorId == 0 && payload.productId == 0x00;
  }

  static List<CommissioningSubStep> _buildSubSteps(
    OnboardingPayload payload,
    ProvisioningTransport transport,
  ) {
    final useBle =
        transport == ProvisioningTransport.androidBle &&
        Platform.isAndroid &&
        !_isShareCode(payload);
    return [
      if (useBle)
        CommissioningSubStep(
          phase: CommissioningPhase.bleScanConnect,
          label: 'BLE scan and connect',
        ),
      CommissioningSubStep(
        phase: CommissioningPhase.controllerSetup,
        label: 'Controller setup',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.secureSession,
        label: 'Secure session',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.readCommissioningInfo,
        label: 'Read commissioning info',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.deviceAttestation,
        label: 'Device attestation',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.nocChainGeneration,
        label: 'NOC chain generation',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.networkProvisioning,
        label: 'Network provisioning',
      ),
      CommissioningSubStep(
        phase: CommissioningPhase.complete,
        label: 'Commissioning complete',
      ),
    ];
  }

  Future<void> start() async {
    if (_started) {
      return;
    }
    _started = true;
    _cleanedUp = false;

    if (shouldUseAndroidBle) {
      _advanceTo(CommissioningPhase.bleScanConnect);
      final device = await BleManager.getDevice(payload);
      _addLog('BLE device: $device');
      if (device != null) {
        for (var i = 0; i < 3; i++) {
          final success = await BleManager.connect(device);
          if (success) {
            connectId = 0x04;
          }
          if (connectId != null) {
            break;
          }
        }
      }

      if (connectId == null) {
        _fail(CommissioningPhase.bleScanConnect, -1, 'BLE device not found');
        _finish(false, -1);
        return;
      }

      _markDone(CommissioningPhase.bleScanConnect);
      final service = _firstWhereOrNull(
        BleManager.getConnDevice()!.servicesList,
        (element) => element.serviceUuid == BleManager.matter_uuid,
      );
      for (final chr in service!.characteristics) {
        final ss = chr.onValueReceived.listen((event) {
          _addLog('BLE indication ${chr.characteristicUuid}: $event');
          BLELayerPlatform.handleIndicationReceived(
            connectId,
            Uint8List.fromList(BleManager.matter_uuid.bytes),
            Uint8List.fromList(chr.characteristicUuid.bytes),
            Uint8List.fromList(event),
          ).then((value) {
            _addLog('handleIndicationReceived $value');
          });
        });
        BleManager.getConnDevice()!.cancelWhenDisconnected(ss);
      }
      await BLELayerPlatform.setBlePlatformDelegate(null);
      await BLELayerPlatform.setBlePlatformDelegate(this);
    }

    try {
      _advanceTo(CommissioningPhase.controllerSetup);
      keypair = await genAsymmetricKeyPair();
      final kp = keypair;
      cert = await getX509Certificate();
      fabricId = await getFabricId();
      final cp = ControllerParams(
        skipCommissioningComplete: false,
        fabricId: fabricId!,
        keypairDelegate: MyKeypairDelegate(
          publicKey: kp.publicKey,
          privateKey: kp.privateKey,
        ),
        ipk: defaultIpk,
        rootCertificate: cert[0],
        intermediateCertificate: cert[0],
        operationalCertificate: cert[1],
      );

      deviceController = await ChipDeviceController.newControllerIfNotExist(cp);
      deviceController!.setNocChainIssuer(this);
      nodeId = await nextNodeId();

      _markDone(CommissioningPhase.controllerSetup);
      _advanceTo(CommissioningPhase.secureSession);
      await deviceController!.pairDevice(
        nodeId!,
        shouldUseAndroidBle ? connectId : null,
        payload.setupPinCode,
        rawCode,
        null,
        NetworkCredentials(wifiCredentials: wifiCredentials),
        attestationDelegate: this,
        completionListener: this,
      );
    } catch (e, s) {
      _addLog('pairDevice error $e $s');
      _fail(_activePhase, -2, e.toString());
      _finish(false, -2);
    }
  }

  Future<void> cleanup() async {
    if (_cleanedUp) {
      return;
    }
    _cleanedUp = true;
    try {
      await BLELayerPlatform.setBlePlatformDelegate(null);
    } catch (e) {
      _addLog('clear BLE delegate error $e');
    }
    try {
      BleManager.disconnectAll();
    } catch (e) {
      _addLog('disconnectAll error $e');
    }
    if (connectId != null) {
      try {
        await bleManager?.disconnect(connectId!);
      } catch (e) {
        _addLog('BLE disconnect error $e');
      }
    }
    if (nodeId != null) {
      try {
        await deviceController?.stopDevicePairing(nodeId!);
      } catch (e) {
        _addLog('stopDevicePairing error $e');
      }
    }
    try {
      await deviceController?.deleteDeviceController();
    } catch (e) {
      _addLog('deleteDeviceController error $e');
    }
  }

  void _addLog(String message) {
    log.add(message);
    onChanged?.call();
  }

  void _advanceTo(CommissioningPhase phase, {String? detail}) {
    final index = subSteps.indexWhere((step) => step.phase == phase);
    if (index < 0) {
      return;
    }
    for (var i = 0; i < index; i++) {
      if (subSteps[i].status != SubStepStatus.error) {
        subSteps[i].status = SubStepStatus.done;
      }
    }
    final step = subSteps[index];
    if (step.status != SubStepStatus.done) {
      step.status = SubStepStatus.active;
    }
    if (detail != null) {
      step.detail = detail;
    }
    onChanged?.call();
  }

  void _markDone(CommissioningPhase phase, {String? detail}) {
    final index = subSteps.indexWhere((step) => step.phase == phase);
    if (index < 0) {
      return;
    }
    for (var i = 0; i <= index; i++) {
      if (subSteps[i].status != SubStepStatus.error) {
        subSteps[i].status = SubStepStatus.done;
      }
    }
    if (detail != null) {
      subSteps[index].detail = detail;
    }
    onChanged?.call();
  }

  void _fail(CommissioningPhase phase, int errorCode, [String? detail]) {
    final index = subSteps.indexWhere((step) => step.phase == phase);
    if (index < 0) {
      return;
    }
    subSteps[index]
      ..status = SubStepStatus.error
      ..detail = detail ?? 'Error $errorCode';
    onChanged?.call();
  }

  void _markAllDone() {
    for (final step in subSteps) {
      step.status = SubStepStatus.done;
    }
    onChanged?.call();
  }

  void _finish(bool success, int errorCode) {
    if (_finished) {
      return;
    }
    _finished = true;
    if (!success) {
      // The fabric id is fixed (getFabricId()), so a controller left running
      // after a failed attempt would block every future attempt with
      // "Create Controller failed". Tear it down now so the user can retry
      // immediately without restarting the app.
      unawaited(cleanup());
    }
    onFinished?.call(success, errorCode);
    onChanged?.call();
  }

  @override
  void onCommissioningComplete(int? nodeId, int errorCode) {
    _addLog('onCommissioningComplete nodeId=$nodeId errorCode=$errorCode');
    if (errorCode == 0 && nodeId != null) {
      _markAllDone();
      saveDevice(Device(
        nodeId,
        vendorId: payload.vendorId,
        productId: payload.productId,
        discriminator: payload.discriminator,
        pairedAt: DateTime.now(),
      ));
      _finish(true, errorCode);
    } else {
      _fail(_activePhase, errorCode, 'Commissioning failed');
      _finish(false, errorCode);
    }
  }

  @override
  void onCommissioningStatusUpdate(int nodeId, String stage, int errorCode) {
    _addLog('$stage (err=$errorCode)');
    if (errorCode != 0) {
      _fail(_activePhase, errorCode, stage);
      _finish(false, errorCode);
    }
  }

  @override
  void onConnectDeviceComplete() {
    _addLog('onConnectDeviceComplete');
  }

  @override
  void onError(Exception error) {
    _addLog('onError $error');
    if (!_finished) {
      _fail(_activePhase, -3, error.toString());
      _finish(false, -3);
    }
  }

  @override
  void onICDRegistrationInfoRequired() {
    _addLog('onICDRegistrationInfoRequired');
  }

  @override
  void onICDRegistrationComplete(int errorCode, ICDDeviceInfo? icdDeviceInfo) {
    _addLog(
      'onICDRegistrationComplete errorCode=$errorCode icdDeviceInfo=$icdDeviceInfo',
    );
  }

  @override
  void onNotifyChipConnectionClosed() {
    _addLog('onNotifyChipConnectionClosed');
  }

  @override
  void onOpCSRGenerationComplete(Uint8List csr) {
    _addLog('onOpCSRGenerationComplete ${base64.encode(csr)}');
  }

  @override
  void onPairingComplete(int errorCode) {
    _addLog('onPairingComplete $errorCode');
    if (errorCode == 0) {
      _markDone(CommissioningPhase.secureSession);
      _advanceTo(CommissioningPhase.readCommissioningInfo);
    } else {
      _fail(CommissioningPhase.secureSession, errorCode);
      _finish(false, errorCode);
    }
  }

  @override
  void onPairingDeleted(int errorCode) {
    _addLog('onPairingDeleted $errorCode');
  }

  @override
  void onReadCommissioningInfo(
    int vendorId,
    int productId,
    int wifiEndpointId,
    int threadEndpointId,
  ) {
    final detail =
        'VID $vendorId, PID $productId, Wi-Fi endpoint $wifiEndpointId, Thread endpoint $threadEndpointId';
    _addLog('onReadCommissioningInfo $detail');
    _markDone(CommissioningPhase.readCommissioningInfo, detail: detail);
    _advanceTo(CommissioningPhase.deviceAttestation);
  }

  @override
  void onStatusUpdate(int status) {
    _addLog('onStatusUpdate $status');
  }

  @override
  void onDeviceAttestationCompleted(
    int devicePtr,
    AttestationInfo? attestationInfo,
    int errorCode,
  ) {
    _addLog('onDeviceAttestationCompleted $errorCode');
    if (errorCode == 0) {
      _markDone(CommissioningPhase.deviceAttestation);
      _advanceTo(CommissioningPhase.nocChainGeneration);
    } else {
      _fail(CommissioningPhase.deviceAttestation, errorCode);
    }
    deviceController!.continueCommissioning(devicePtr, true);
  }

  @override
  Future<bool> closeConnection(connObj) async {
    await BleManager.getConnDevice()!.disconnect();
    return true;
  }

  @override
  Future<int> getMTU(connObj) async {
    final mtu = BleManager.getConnDevice()!.mtuNow;
    _addLog('getMTU $connObj -> $mtu');
    return mtu;
  }

  @override
  Future<bool> sendIndication(
    connObj,
    Uint8List svcId,
    Uint8List charId,
    Uint8List pBuf,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendReadRequest(
    connObj,
    Uint8List svcId,
    Uint8List charId,
    Uint8List pBuf,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendReadResponse(
    connObj,
    requestContext,
    Uint8List svcId,
    Uint8List charId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<bool> sendWriteRequest(
    connObj,
    Uint8List svcId,
    Uint8List charId,
    Uint8List pBuf,
  ) async {
    _addLog(
      'sendWriteRequest $connObj ${HEX.encode(svcId)} ${HEX.encode(charId)} ${HEX.encode(pBuf)}',
    );
    var writeSuccess = false;
    final service = _firstWhereOrNull(
      BleManager.getConnDevice()!.servicesList,
      (element) => element.serviceUuid == Guid.fromBytes(svcId),
    );
    final char = service == null
        ? null
        : _firstWhereOrNull(
            service.characteristics,
            (element) => element.characteristicUuid == Guid.fromBytes(charId),
          );
    if (char != null) {
      await char
          .write(pBuf, withoutResponse: false)
          .then((value) {
            writeSuccess = true;
            Future(() {
              BLELayerPlatform.handleWriteConfirmation(
                connObj,
                svcId,
                charId,
                true,
              );
            });
            return value;
          })
          .catchError((_) {
            writeSuccess = false;
            Future(() {
              BLELayerPlatform.handleWriteConfirmation(
                connObj,
                svcId,
                charId,
                false,
              );
            });
          });
    }
    return writeSuccess;
  }

  @override
  Future<bool> subscribeCharacteristic(
    connObj,
    Uint8List svcId,
    Uint8List charId,
  ) async {
    _addLog(
      'subscribeCharacteristic $connObj ${HEX.encode(svcId)} ${HEX.encode(charId)}',
    );
    final service = _firstWhereOrNull(
      BleManager.getConnDevice()!.servicesList,
      (element) => element.serviceUuid == Guid.fromBytes(svcId),
    );
    final char = service == null
        ? null
        : _firstWhereOrNull(
            service.characteristics,
            (element) => element.characteristicUuid == Guid.fromBytes(charId),
          );
    return await char?.setNotifyValue(true).catchError((e) => false).then((v) {
          Future(() {
            BLELayerPlatform.handleSubscribeComplete(connObj, svcId, charId, v);
          });
          return v;
        }) ??
        false;
  }

  @override
  Future<bool> unsubscribeCharacteristic(
    connObj,
    Uint8List svcId,
    Uint8List charId,
  ) async {
    final service = _firstWhereOrNull(
      BleManager.getConnDevice()!.servicesList,
      (element) => element.serviceUuid == Guid.fromBytes(svcId),
    );
    final char = service == null
        ? null
        : _firstWhereOrNull(
            service.characteristics,
            (element) => element.characteristicUuid == Guid.fromBytes(charId),
          );
    return await char?.setNotifyValue(false).catchError((e) => false) ?? false;
  }

  @override
  void onNOCChainGenerationNeeded(
    onNOCChainGenerationCompleteHandle,
    CSRInfo csrInfo,
    AttestationInfo attestationInfo,
  ) async {
    final pubKey = await deviceController!.publicKeyFromCSR(csrInfo.csr);
    final kpd = MyKeypairDelegate(
      publicKey: keypair.publicKey,
      privateKey: keypair.privateKey,
    );
    final deviceNOC = await ChipDeviceController.createOperationalCertificate(
      kpd,
      cert[0],
      pubKey,
      fabricId!,
      nodeId!,
      null,
    );
    _markDone(CommissioningPhase.nocChainGeneration);
    _advanceTo(CommissioningPhase.networkProvisioning);
    deviceController!.onNOCChainGeneration(
      ControllerParams(
        rootCertificate: cert[0],
        intermediateCertificate: cert[0],
        operationalCertificate: deviceNOC,
        adminSubject: kTestControllerNodeId,
        keypairDelegate: kpd,
        ipk: defaultIpk,
      ),
      onNOCChainGenerationCompleteHandle: onNOCChainGenerationCompleteHandle,
    );
  }
}

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T item) test) {
  for (final item in items) {
    if (test(item)) {
      return item;
    }
  }
  return null;
}
