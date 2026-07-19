import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_matter/flutter_matter.dart';
import 'package:flutter_matter_example/commissioning_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InputMode { qr, manualCode }

class CommissioningPage extends StatefulWidget {
  const CommissioningPage({super.key});

  @override
  State<CommissioningPage> createState() => _CommissioningPageState();
}

class _CommissioningPageState extends State<CommissioningPage> {
  final _networkInfo = NetworkInfo();
  final _manualCodeController = TextEditingController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();

  MobileScannerController? _scannerController;
  InputMode _inputMode = InputMode.qr;
  int _currentStep = 0;
  bool _isParsing = false;
  bool _isCommissioning = false;
  bool _commissioningFinished = false;
  bool _commissioningSucceeded = false;
  int? _commissioningErrorCode;
  OnboardingPayload? _payload;
  String? _rawCode;
  ProvisioningTransport _transport = ProvisioningTransport.androidBle;
  CommissioningController? _controller;

  @override
  void initState() {
    super.initState();
    _ensureScanner();
    SharedPreferences.getInstance().then((sp) {
      if (!mounted) {
        return;
      }
      setState(() {
        _ssidController.text = sp.getString('wifi_ssid') ?? '';
        _passwordController.text = sp.getString('wifi_password') ?? '';
      });
    });
    _fillIosSsidIfAvailable();
  }

  @override
  void dispose() {
    _controller?.cleanup();
    _scannerController?.dispose();
    _manualCodeController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String?> _getCurrentIosSsid() async {
    if (!Platform.isIOS) {
      return null;
    }
    final permissionStatus = await Permission.locationWhenInUse.request();
    if (!permissionStatus.isGranted) {
      return null;
    }
    final ssid = await _networkInfo.getWifiName();
    if (ssid == null) {
      return null;
    }
    final normalizedSsid = ssid.replaceAll('"', '').trim();
    if (normalizedSsid.isEmpty) {
      return null;
    }
    return normalizedSsid;
  }

  Future<void> _fillIosSsidIfAvailable() async {
    final ssid = await _getCurrentIosSsid().catchError((_) => null);
    if (!mounted || ssid == null || _ssidController.text.trim().isNotEmpty) {
      return;
    }
    setState(() {
      _ssidController.text = ssid;
    });
  }

  void _ensureScanner() {
    _scannerController ??= MobileScannerController();
  }

  Future<void> _disposeScanner() async {
    final scanner = _scannerController;
    _scannerController = null;
    await scanner?.dispose();
  }

  Future<void> _parseCode(String code) async {
    if (_isParsing) {
      return;
    }
    final trimmed = code.trim();
    if (trimmed.isEmpty) {
      Fluttertoast.showToast(msg: 'Invalid pairing code');
      return;
    }
    setState(() {
      _isParsing = true;
    });
    try {
      final payload = await OnboardingPayloadParser().parse(trimmed);
      if (!mounted) {
        return;
      }
      setState(() {
        _payload = payload;
        _rawCode = trimmed;
        _transport = _canUseBle(payload)
            ? ProvisioningTransport.androidBle
            : ProvisioningTransport.onNetwork;
        _currentStep = 1;
        _isParsing = false;
      });
      await _disposeScanner();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isParsing = false;
      });
      Fluttertoast.showToast(msg: 'Invalid pairing code');
    }
  }

  bool _canUseBle(OnboardingPayload payload) {
    final isShare = payload.vendorId == 0 && payload.productId == 0x00;
    return Platform.isAndroid && !isShare;
  }

  Future<void> _continueFromCodeStep() async {
    if (_payload != null) {
      setState(() {
        _currentStep = 1;
      });
      await _disposeScanner();
      return;
    }
    if (_inputMode == InputMode.manualCode) {
      await _parseCode(_manualCodeController.text);
    } else {
      Fluttertoast.showToast(msg: 'Scan a QR code or switch to manual entry');
    }
  }

  Future<void> _continueFromWifiStep() async {
    final ssid = _ssidController.text.trim();
    final password = _passwordController.text;
    if (ssid.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter Wi-Fi name');
      return;
    }
    final sp = await SharedPreferences.getInstance();
    await sp.setString('wifi_ssid', ssid);
    await sp.setString('wifi_password', password);
    if (!mounted) {
      return;
    }
    setState(() {
      _currentStep = 2;
    });
  }

  Future<bool> _confirmWifiCredentials() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final ssidEmpty = _ssidController.text.trim().isEmpty;
            final passwordEmpty = _passwordController.text.isEmpty;
            return AlertDialog(
              title: const Text('Confirm Wi-Fi credentials'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _ssidController,
                    decoration: const InputDecoration(labelText: 'Wi-Fi name'),
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Wi-Fi password',
                    ),
                    obscureText: true,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  if (passwordEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Password is empty. Only continue if this is an open network.',
                      style: TextStyle(
                        color: Theme.of(dialogContext).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: ssidEmpty
                      ? null
                      : () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Start provisioning'),
                ),
              ],
            );
          },
        );
      },
    );
    return result ?? false;
  }

  Future<void> _startCommissioning() async {
    final payload = _payload;
    final rawCode = _rawCode;
    if (payload == null || rawCode == null) {
      Fluttertoast.showToast(msg: 'Invalid pairing code');
      return;
    }
    final confirmed = await _confirmWifiCredentials();
    if (!confirmed || !mounted) {
      return;
    }
    final ssid = _ssidController.text.trim();
    final password = _passwordController.text;
    final sp = await SharedPreferences.getInstance();
    await sp.setString('wifi_ssid', ssid);
    await sp.setString('wifi_password', password);
    if (!mounted) {
      return;
    }
    final controller = CommissioningController(
      payload: payload,
      rawCode: rawCode,
      wifiCredentials: WiFiCredentials(ssid: ssid, password: password),
      transport: _transport,
    );
    controller.onChanged = () {
      if (mounted) {
        setState(() {});
      }
    };
    controller.onFinished = (success, errorCode) {
      if (mounted) {
        setState(() {
          _commissioningFinished = true;
          _commissioningSucceeded = success;
          _commissioningErrorCode = errorCode;
          _isCommissioning = false;
        });
      }
    };
    setState(() {
      _controller = controller;
      _currentStep = 3;
      _isCommissioning = true;
      _commissioningFinished = false;
      _commissioningSucceeded = false;
      _commissioningErrorCode = null;
    });
    await controller.start();
  }

  Future<void> _retry() async {
    await _controller?.cleanup();
    if (!mounted) {
      return;
    }
    setState(() {
      _controller = null;
      _isCommissioning = false;
      _commissioningFinished = false;
      _commissioningSucceeded = false;
      _commissioningErrorCode = null;
      _currentStep = 2;
    });
  }

  Future<bool> _confirmLeave() async {
    if (!_isCommissioning) {
      return true;
    }
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave commissioning?'),
          content: const Text(
            'Commissioning is still running. Leaving will stop the current attempt.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );
    return shouldLeave == true;
  }

  void _handleStepTapped(int step) {
    if (_isCommissioning) {
      return;
    }
    if (_controller != null && !_commissioningSucceeded) {
      return;
    }
    if (step <= _currentStep) {
      setState(() {
        _currentStep = step;
        if (step == 0 && _inputMode == InputMode.qr) {
          _ensureScanner();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isCommissioning,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final navigator = Navigator.of(context);
        if (await _confirmLeave() && mounted) {
          await _controller?.cleanup();
          if (!mounted) {
            return;
          }
          setState(() {
            _isCommissioning = false;
          });
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Commission device')),
        body: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: _handleStepTapped,
          controlsBuilder: _buildControls,
          steps: [
            Step(
              title: const Text('Device code'),
              isActive: _currentStep == 0,
              state: _payload == null ? StepState.indexed : StepState.complete,
              content: _buildDeviceCodeStep(),
            ),
            Step(
              title: const Text('Wi-Fi'),
              isActive: _currentStep == 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: _buildWifiStep(),
            ),
            Step(
              title: const Text('Transport & confirm'),
              isActive: _currentStep == 2,
              state: _currentStep > 2 ? StepState.complete : StepState.indexed,
              content: _buildTransportStep(),
            ),
            Step(
              title: const Text('Progress'),
              isActive: _currentStep == 3,
              state: _commissioningFinished
                  ? (_commissioningSucceeded
                        ? StepState.complete
                        : StepState.error)
                  : StepState.indexed,
              content: _buildProgressStep(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    if (_currentStep == 3) {
      if (!_commissioningFinished) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            if (_commissioningSucceeded)
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Done'),
              )
            else
              FilledButton(onPressed: _retry, child: const Text('Retry')),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          FilledButton(
            onPressed: _currentStep == 0
                ? _continueFromCodeStep
                : _currentStep == 1
                ? _continueFromWifiStep
                : _startCommissioning,
            child: Text(_currentStep == 2 ? 'Start commissioning' : 'Continue'),
          ),
          if (_currentStep > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  _currentStep -= 1;
                  if (_currentStep == 0 && _inputMode == InputMode.qr) {
                    _ensureScanner();
                  }
                });
              },
              child: const Text('Back'),
            ),
        ],
      ),
    );
  }

  Widget _buildDeviceCodeStep() {
    final payload = _payload;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<InputMode>(
          segments: const [
            ButtonSegment(value: InputMode.qr, label: Text('QR scan')),
            ButtonSegment(
              value: InputMode.manualCode,
              label: Text('Manual code'),
            ),
          ],
          selected: {_inputMode},
          onSelectionChanged: (selection) async {
            final mode = selection.first;
            setState(() {
              _inputMode = mode;
            });
            if (mode == InputMode.qr) {
              _ensureScanner();
            } else {
              await _disposeScanner();
            }
          },
        ),
        const SizedBox(height: 16),
        if (_inputMode == InputMode.qr)
          SizedBox(
            height: 280,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _scannerController == null
                  ? const Center(child: CircularProgressIndicator())
                  : MobileScanner(
                      controller: _scannerController,
                      onDetect: (barcodes) {
                        final code = barcodes.barcodes.isEmpty
                            ? null
                            : barcodes.barcodes.first.displayValue;
                        if (code != null) {
                          _parseCode(code);
                        }
                      },
                    ),
            ),
          )
        else
          TextField(
            controller: _manualCodeController,
            decoration: const InputDecoration(
              labelText: '11-digit pairing code',
              counterText: '',
            ),
            keyboardType: TextInputType.number,
            maxLength: 11,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            onSubmitted: _parseCode,
          ),
        if (_isParsing)
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: LinearProgressIndicator(),
          ),
        if (payload != null) ...[
          const SizedBox(height: 16),
          _SummaryCard(
            children: [
              _SummaryLine('Vendor', payload.vendorId.toRadixString(16)),
              _SummaryLine('Product', payload.productId.toRadixString(16)),
              _SummaryLine('Discriminator', payload.discriminator.toString()),
              _SummaryLine('Setup PIN', payload.setupPinCode.toString()),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildWifiStep() {
    if (_payload == null) {
      return const Text('Scan or enter a device code first.');
    }
    return Column(
      children: [
        TextField(
          controller: _ssidController,
          decoration: const InputDecoration(labelText: 'Wi-Fi name'),
        ),
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
            labelText: 'Wi-Fi password',
            helperText: 'Leave empty for open networks',
          ),
        ),
      ],
    );
  }

  Widget _buildTransportStep() {
    final payload = _payload;
    final canUseBle = payload != null && _canUseBle(payload);
    if (!canUseBle && _transport == ProvisioningTransport.androidBle) {
      _transport = ProvisioningTransport.onNetwork;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SegmentedButton<ProvisioningTransport>(
          segments: [
            ButtonSegment(
              value: ProvisioningTransport.androidBle,
              enabled: canUseBle,
              label: const Text('BLE'),
            ),
            const ButtonSegment(
              value: ProvisioningTransport.onNetwork,
              label: Text('On-network'),
            ),
          ],
          selected: {_transport},
          onSelectionChanged: (selection) {
            setState(() {
              _transport = selection.first;
            });
          },
        ),
        const SizedBox(height: 8),
        Text(
          canUseBle
              ? 'BLE scans and connects to the Matter BLE advertisement. On-network skips BLE and commissions with the onboarding code.'
              : 'BLE is unavailable on iOS, share codes, or non-Android devices.',
        ),
        const SizedBox(height: 8),
        _SummaryCard(
          children: [
            _SummaryLine('Code', _rawCode ?? ''),
            _SummaryLine('Wi-Fi', _ssidController.text.trim()),
            _SummaryLine(
              'Transport',
              _transport == ProvisioningTransport.androidBle
                  ? 'Android BLE'
                  : 'On-network',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressStep() {
    final controller = _controller;
    if (controller == null) {
      return const Text('Commissioning has not started.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final step in controller.subSteps) _ProgressRow(step: step),
        const SizedBox(height: 12),
        if (_commissioningFinished && !_commissioningSucceeded)
          Text(
            'Commissioning failed with code $_commissioningErrorCode',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('Native log'),
          children: [
            if (controller.log.isEmpty)
              const ListTile(title: Text('No native callbacks yet.'))
            else
              for (final line in controller.log)
                ListTile(dense: true, title: Text(line)),
          ],
        ),
      ],
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final CommissioningSubStep step;

  const _ProgressRow({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: _iconForStatus(context, step.status),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.label),
                if (step.detail != null)
                  Text(
                    step.detail!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconForStatus(BuildContext context, SubStepStatus status) {
    switch (status) {
      case SubStepStatus.pending:
        return Icon(
          Icons.radio_button_unchecked,
          color: Theme.of(context).disabledColor,
          size: 20,
        );
      case SubStepStatus.active:
        return const Padding(
          padding: EdgeInsets.all(4),
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case SubStepStatus.done:
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case SubStepStatus.error:
        return Icon(
          Icons.error,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        );
    }
  }
}

class _SummaryCard extends StatelessWidget {
  final List<Widget> children;

  const _SummaryCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
