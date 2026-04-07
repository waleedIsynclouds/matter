import 'dart:typed_data';

import '../utils.dart';

/// Information about an ICD (Intermittently Connected Device) returned after
/// successful ICD registration during commissioning (Matter 1.2+).
class ICDDeviceInfo {
  /// The 16-byte symmetric key used for ICD check-ins.
  final Uint8List symmetricKey;

  /// Bitmask of trigger hints that describe how to wake up the ICD.
  final List<int> userActiveModeTriggerHint;

  /// Human-readable instruction that accompanies the trigger hint, if any.
  final String userActiveModeTriggerInstruction;

  /// The Node ID of the ICD device on the fabric.
  final int icdNodeId;

  /// The ICD counter value at the time of registration.
  final int icdCounter;

  /// The monitored subject used for check-in messages.
  final int monitoredSubject;

  /// The Fabric ID the ICD was registered on.
  final int fabricId;

  /// The index of the fabric on the commissioner.
  final int fabricIndex;

  ICDDeviceInfo({
    required this.symmetricKey,
    required this.userActiveModeTriggerHint,
    required this.userActiveModeTriggerInstruction,
    required this.icdNodeId,
    required this.icdCounter,
    required this.monitoredSubject,
    required this.fabricId,
    required this.fabricIndex,
  });

  factory ICDDeviceInfo.fromJson(Map<String, dynamic> json) {
    return ICDDeviceInfo(
      symmetricKey: toUint8List(json['symmetricKey']),
      userActiveModeTriggerHint:
          (json['userActiveModeTriggerHint'] as List<dynamic>).cast<int>(),
      userActiveModeTriggerInstruction:
          json['userActiveModeTriggerInstruction']?.toString() ?? '',
      icdNodeId: json['icdNodeId'] as int,
      icdCounter: json['icdCounter'] as int,
      monitoredSubject: json['monitoredSubject'] as int,
      fabricId: json['fabricId'] as int,
      fabricIndex: json['fabricIndex'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'symmetricKey': List<int>.from(symmetricKey),
        'userActiveModeTriggerHint': userActiveModeTriggerHint,
        'userActiveModeTriggerInstruction': userActiveModeTriggerInstruction,
        'icdNodeId': icdNodeId,
        'icdCounter': icdCounter,
        'monitoredSubject': monitoredSubject,
        'fabricId': fabricId,
        'fabricIndex': fabricIndex,
      };
}
