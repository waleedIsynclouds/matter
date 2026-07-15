# anatomy.md

> Auto-maintained by OpenWolf. Last scanned: 2026-07-12T22:17:10.992Z
> Files: 202 tracked | Anatomy hits: 0 | Misses: 0

## ./

- `.gitignore` — Git ignore rules (~156 tok)
- `analysis_options.yaml` (~46 tok)
- `CHANGELOG.md` — Change log (~1156 tok)
- `CLAUDE.md` — OpenWolf (~57 tok)
- `LICENSE` — Project license (~495 tok)
- `pubspec.yaml` — Dart/Flutter package manifest (~761 tok)
- `README.md` — Project documentation (~1312 tok)

## .claude/

- `settings.json` (~441 tok)

## .claude/rules/

- `openwolf.md` (~313 tok)

## android/

- `.gitignore` — Git ignore rules (~30 tok)
- `build.gradle` (~480 tok)
- `gradlew` — you may not use this file except in compliance with the License. (~2379 tok)
- `gradlew.bat` (~765 tok)
- `proguard-rules.pro` — Declares chip (~9 tok)
- `settings.gradle` — Gradle settings (~10 tok)

## android/gradle/wrapper/

- `gradle-wrapper.jar` (~11077 tok)
- `gradle-wrapper.properties` (~69 tok)

## android/src/main/

- `AndroidManifest.xml` (~26 tok)

## android/src/main/kotlin/com/tyx/flutter_matter/

- `BLE.kt` — onBLECall, callResultSuccess, callResultError, connectDevice, disconnect (~3027 tok)
- `BluetoothManager.kt` — Connects to a [BluetoothDevice] and suspends until [BluetoothGattCallback.onServicesDiscovered] (~3003 tok)
- `ChipClient.kt` — Lazily instantiates [ChipDeviceController] and holds a reference to it. (~1439 tok)
- `Constant.kt` — Declares val (~59 tok)
- `DeviceControl.kt` — KeypairDelegateWarp: getDeviceController, CSRInfo, AttestationInfo, ICDDeviceInfo + 10 more (~17756 tok)
- `ExampleAttestationTrustStoreDelegate.kt` — ExampleAttestationTrustStoreDelegate: getProductAttestationAuthorityCert (~601 tok)
- `FlutterMatterPlugin.kt` — FlutterMatterPlugin (~609 tok)
- `Nsd.kt` — CustomNsdManagerServiceResolver: resolve, publish, removeServices, handleServiceResolve + 9 more (~3390 tok)
- `Onboarding.kt` — onOnboardingCall, parseManualPairingCode, parseQrCode (~480 tok)
- `Utils.kt` — createFlutterCallPath, isOnMainThread, createCallFlutterExceptionMessage, ByteArray, JSONArray (~1035 tok)

## android/src/test/kotlin/com/tyx/flutter_matter/

- `FlutterMatterPluginTest.kt` — FlutterMatterPluginTest: onMethodCall_getPlatformVersion_returnsExpectedValue (~267 tok)

## example/

- `.gitignore` — Git ignore rules (~196 tok)
- `.metadata` — This file tracks properties of this Flutter project. (~469 tok)
- `analysis_options.yaml` — This file configures the analyzer, which statically analyzes Dart code to (~414 tok)
- `pubspec.yaml` — Dart/Flutter package manifest (~1091 tok)
- `README.md` — Project documentation (~153 tok)

## example/android/

- `.gitignore` — Git ignore rules (~80 tok)
- `build.gradle` (~103 tok)
- `gradle.properties` (~37 tok)
- `settings.gradle` (~219 tok)

## example/android/app/

- `build.gradle` (~545 tok)

## example/android/app/src/debug/

- `AndroidManifest.xml` (~110 tok)

## example/android/app/src/main/

- `AndroidManifest.xml` (~1007 tok)

## example/android/app/src/main/kotlin/com/flutter/example/

- `MainActivity.kt` — Declares MainActivity (~35 tok)

## example/android/app/src/main/res/drawable-v21/

- `launch_background.xml` (~129 tok)

## example/android/app/src/main/res/drawable/

- `launch_background.xml` (~128 tok)

## example/android/app/src/main/res/values-night/

- `styles.xml` (~290 tok)

## example/android/app/src/main/res/values/

- `styles.xml` (~290 tok)

## example/android/app/src/profile/

- `AndroidManifest.xml` (~110 tok)

## example/android/gradle/wrapper/

- `gradle-wrapper.properties` (~55 tok)

## example/integration_test/

- `plugin_integration_test.dart` — This is a basic Flutter integration test. (~186 tok)

## example/ios/

- `.gitignore` — Git ignore rules (~161 tok)
- `Podfile` — Uncomment this line to define a global platform for your project (~441 tok)

## example/ios/Flutter/

- `AppFrameworkInfo.plist` (~214 tok)
- `Debug.xcconfig` — include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig" (~30 tok)
- `Release.xcconfig` — include? "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig" (~30 tok)

## example/ios/MatterExt/

- `Info.plist` (~135 tok)
- `MatterExt.entitlements` (~100 tok)
- `RequestHandler.swift` — RequestHandler.swift (~761 tok)

## example/ios/Runner.xcodeproj/

- `project.pbxproj` — !$*UTF8*$! (~10944 tok)

## example/ios/Runner.xcodeproj/project.xcworkspace/

- `contents.xcworkspacedata` (~38 tok)

## example/ios/Runner.xcodeproj/project.xcworkspace/xcshareddata/

- `IDEWorkspaceChecks.plist` (~66 tok)
- `WorkspaceSettings.xcsettings` (~63 tok)

## example/ios/Runner.xcodeproj/xcshareddata/xcschemes/

- `Runner.xcscheme` (~1000 tok)

## example/ios/Runner.xcworkspace/

- `contents.xcworkspacedata` (~63 tok)

## example/ios/Runner.xcworkspace/xcshareddata/

- `IDEWorkspaceChecks.plist` (~66 tok)
- `WorkspaceSettings.xcsettings` (~63 tok)

## example/ios/Runner/

- `AppDelegate.swift` — AppDelegate: application (~112 tok)
- `Info.plist` (~680 tok)
- `Runner-Bridging-Header.h` — import "GeneratedPluginRegistrant.h" (~12 tok)
- `Runner.entitlements` (~117 tok)

## example/ios/Runner/Assets.xcassets/AppIcon.appiconset/

- `Contents.json` (~755 tok)

## example/ios/Runner/Assets.xcassets/LaunchImage.imageset/

- `Contents.json` (~119 tok)
- `README.md` — Project documentation (~85 tok)

## example/ios/Runner/Base.lproj/

- `LaunchScreen.storyboard` (~644 tok)
- `Main.storyboard` (~435 tok)

## example/ios/RunnerTests/

- `RunnerTests.swift` — RunnerTests: testExample (~80 tok)

## example/lib/

- `ble_manager.dart` — BleManager: disconnectAll (~711 tok)
- `control_page.dart` — Stateful widget: ControlPage (~4171 tok)
- `data.dart` — MyKeypairDelegate: generatePrivateKey (~2407 tok)
- `device_provisioning.dart` — Stateful widget: DeviceProvisioningPage (~3606 tok)
- `home_page.dart` — Stateful widget: HomePage (~489 tok)
- `main.dart` — Declares MaterialApp (~54 tok)
- `onboarding.dart` — Stateful widget: OnboardingWidget (~963 tok)
- `uitls.dart` (~36 tok)
- `wifi_input.dart` — Stateful widget: WifiInputPage (~726 tok)

## example/test/

- `widget_test.dart` — This is a basic Flutter widget test. (~132 tok)

## ios/

- `.gitignore` — Git ignore rules (~122 tok)
- `flutter_matter.podspec` — To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html. (~311 tok)

## ios/Assets/

- `.gitkeep` (~0 tok)

## ios/Classes/

- `BleHandle.h` — import <Flutter/Flutter.h> (~96 tok)
- `BleHandle.m` — BleHandle.m (~2530 tok)
- `Constants.h` — Declares Constants (~84 tok)
- `Constants.m` — import <Foundation/Foundation.h> (~106 tok)
- `DeviceAttestationDelegate.h` — import <Foundation/Foundation.h> (~78 tok)
- `DeviceAttestationDelegate.m` — import "DeviceAttestationDelegate.h" (~578 tok)
- `DeviceControlHandle.h` — import <Flutter/Flutter.h> (~304 tok)
- `DeviceControlHandle.m` — 禁用某个警告（在文件顶部添加） (~19258 tok)
- `FlutterControllerParams.h` — import <Foundation/Foundation.h> (~697 tok)
- `FlutterControllerParams.m` — include "FlutterControllerParams.h" (~631 tok)
- `FlutterDeviceController.h` — import "FlutterControllerParams.h" (~198 tok)
- `FlutterDeviceController.m` — import "FlutterDeviceController.h" (~334 tok)
- `FlutterMatterPlugin.h` — import <Flutter/Flutter.h> (~29 tok)
- `FlutterMatterPlugin.m` — import "FlutterMatterPlugin.h" (~457 tok)
- `Global.h` — import "Flutter/Flutter.h" (~84 tok)
- `Global.m` — import "Global.h" (~305 tok)
- `MatterDevicePair.swift` — MatterDevicePair: startPairDevice (~777 tok)
- `Onboarding.h` — import <Foundation/Foundation.h> (~43 tok)
- `Onboarding.m` — include "Onboarding.h" (~1037 tok)
- `Utiles.h` — include <Foundation/Foundation.h> (~242 tok)
- `Utiles.m` — import "Utiles.h" (~1572 tok)

## ios/Classes/Framework Helpers/

- `DefaultsUtils.h` — *    Copyright (c) 2020 Project CHIP Authors (~633 tok)
- `DefaultsUtils.m` — *    Copyright (c) 2020 Project CHIP Authors (~2403 tok)
- `FabricKeys.h` — Copyright (c) 2022 Project CHIP Authors (~285 tok)
- `FabricKeys.m` — Copyright (c) 2022 Project CHIP Authors (~2121 tok)

## ios/frameworks/ZGMatter.framework/

- `Info.plist` (~200 tok)

## ios/frameworks/ZGMatter.framework/Headers/

- `ZGMatter.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~917 tok)
- `ZGMTRAccessGrant.h` — Copyright (c) 2024 Project CHIP Authors (~894 tok)
- `ZGMTRAsyncCallbackWorkQueue.h` — *    Copyright (c) 2022 Project CHIP Authors (~538 tok)
- `ZGMTRBackwardsCompatShims.h` — Copyright (c) 2023 Project CHIP Authors (~161226 tok)
- `ZGMTRBaseDevice.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~13917 tok)
- `ZGMTRBleManager.h` — *    Copyright (c) 2024 Project CHIP Authors (~524 tok)
- `ZGMTRBlePlatformDelegate.h` — *    Copyright (c) 2024 Project CHIP Authors (~510 tok)
- `ZGMTRCertificateInfo.h` — Copyright (c) 2023 Project CHIP Authors (~1067 tok)
- `ZGMTRCertificates.h` — Copyright (c) 2022-2023 Project CHIP Authors (~3880 tok)
- `ZGMTRCluster.h` — ZGMTRCluster (~2923 tok)
- `ZGMTRClusterConstants.h` (~235104 tok)
- `ZGMTRClusterNames.h` — This file defines functions to resolve Matter cluster and attribute IDs into (~836 tok)
- `ZGMTRClusters.h` — Cluster Identify (~235029 tok)
- `ZGMTRClusterStateCacheContainer.h` — Copyright (c) 2022-2023 Project CHIP Authors (~851 tok)
- `ZGMTRCommandPayloadsObjc.h` — Controls whether the command is a timed command (using Timed Invoke). (~196193 tok)
- `ZGMTRCommissionableBrowserDelegate.h` — *    Copyright (c) 2023 Project CHIP Authors (~415 tok)
- `ZGMTRCommissionableBrowserResult.h` — *    Copyright (c) 2023 Project CHIP Authors (~536 tok)
- `ZGMTRCommissioningParameters.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~1128 tok)
- `ZGMTRCSRInfo.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~1319 tok)
- `ZGMTRDefines.h` — *    Copyright (c) 2022 Project CHIP Authors (~1065 tok)
- `ZGMTRDevice.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~6404 tok)
- `ZGMTRDeviceAttestationDelegate.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~1657 tok)
- `ZGMTRDeviceAttestationInfo.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~1296 tok)
- `ZGMTRDeviceController.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~5533 tok)
- `ZGMTRDeviceController+XPC.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~2628 tok)
- `ZGMTRDeviceControllerDelegate.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~1888 tok)
- `ZGMTRDeviceControllerFactory.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~3166 tok)
- `ZGMTRDeviceControllerParameters.h` — Copyright (c) 2023 Project CHIP Authors (~2212 tok)
- `ZGMTRDeviceControllerStartupParams.h` — Copyright (c) 2022-2023 Project CHIP Authors (~3581 tok)
- `ZGMTRDeviceControllerStorageDelegate.h` — Copyright (c) 2023 Project CHIP Authors (~1707 tok)
- `ZGMTRDeviceStorageBehaviorConfiguration.h` — Copyright (c) 2024 Project CHIP Authors (~1462 tok)
- `ZGMTRDeviceTypeRevision.h` — Copyright (c) 2024 Project CHIP Authors (~467 tok)
- `ZGMTRDiagnosticLogsType.h` — *    Copyright (c) 2024 Project CHIP Authors (~352 tok)
- `ZGMTRError.h` — *    Copyright (c) 2020 Project CHIP Authors (~2063 tok)
- `ZGMTRFabricInfo.h` — Copyright (c) 2023 Project CHIP Authors (~930 tok)
- `ZGMTRKeypair.h` — *    Copyright (c) 2021 Project CHIP Authors (~583 tok)
- `ZGMTRLogging.h` — Arranges for log messages from the Matter stack to be delivered to a callback block. (~488 tok)
- `ZGMTRManualSetupPayloadParser.h` — *    Copyright (c) 2020 Project CHIP Authors (~333 tok)
- `ZGMTRMetrics.h` — *    Copyright (c) 2024 Project CHIP Authors (~723 tok)
- `ZGMTROnboardingPayloadParser.h` — *    Copyright (c) 2020 Project CHIP Authors (~440 tok)
- `ZGMTROperationalCertificateIssuer.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~1680 tok)
- `ZGMTROTAHeader.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~1541 tok)
- `ZGMTROTAProviderDelegate.h` — *    Copyright (c) 2022-2023 Project CHIP Authors (~2665 tok)
- `ZGMTRQRCodeSetupPayloadParser.h` — *    Copyright (c) 2020 Project CHIP Authors (~329 tok)
- `ZGMTRServerAttribute.h` — Copyright (c) 2024 Project CHIP Authors (~847 tok)
- `ZGMTRServerCluster.h` — Copyright (c) 2024 Project CHIP Authors (~1166 tok)
- `ZGMTRServerEndpoint.h` — Copyright (c) 2024 Project CHIP Authors (~910 tok)
- `ZGMTRSetupPayload.h` — *    Copyright (c) 2020-2024 Project CHIP Authors (~3464 tok)
- `ZGMTRStorage.h` — *    Copyright (c) 2020-2023 Project CHIP Authors (~555 tok)
- `ZGMTRStructsObjc.h` — Declares ZGMTRDataTypeTestGlobalStruct (~54414 tok)
- `ZGMTRThreadOperationalDataset.h` — *    Copyright (c) 2021-2023 Project CHIP Authors (~1523 tok)
- `ZGMTRXPCClientProtocol.h` — Copyright (c) 2024 Project CHIP Authors (~644 tok)
- `ZGMTRXPCServerProtocol.h` — Copyright (c) 2024 Project CHIP Authors (~1810 tok)
- `ZGTlv.h` — ZGTlv.h (~557 tok)

## ios/frameworks/ZGMatter.framework/Modules/

- `module.modulemap` (~28 tok)

## lib/

- `flutter_matter_method_channel.dart` — PlatformResult: toString, toString, encode, match (~938 tok)
- `flutter_matter_platform_interface.dart` — FlutterMatterPlatform: instance (~245 tok)
- `flutter_matter.dart` (~262 tok)

## lib/src/

- `ble.dart` — Declares String (~5083 tok)
- `callback_handler.dart` — CallbackHandler: addHandler, removeHandler, match (~374 tok)
- `constant.dart` — Declares jsonKeyHandle (~18 tok)
- `controller.dart` — Represents information relating to NOC CSR. (~14382 tok)
- `exception.dart` — Declares successCode (~56 tok)
- `nsd.dart` — ResolveCallback: resolve, Function, removeServices, publish (~1577 tok)
- `onboarding.dart` — Declares String (~1044 tok)
- `utils.dart` (~250 tok)

## lib/src/clusters/

- `basic_information_cluster.dart` — Declares BasicInformationCluster (~1363 tok)
- `descriptor_cluster.dart` — Declares DescriptorCluster (~1183 tok)

## lib/src/model/

- `attribute_state.dart` — Declares AttributeState (~97 tok)
- `attribute_write_request.dart` — Declares AttributeWriteRequest (~185 tok)
- `chip_attribute_path.dart` — Declares ChipAttributePath (~188 tok)
- `chip_event_path.dart` — Declares ChipEventPath (~130 tok)
- `chip_path_id.dart` — Declares IdType (~167 tok)
- `cluster_state.dart` — Declares ClusterState (~427 tok)
- `data_version_filter.dart` — Declares DataVersionFilter (~111 tok)
- `endpoint_state.dart` — Declares EndpointState (~92 tok)
- `event_state.dart` — Declares EventState (~201 tok)
- `icd_device_info.dart` — / Information about an ICD (Intermittently Connected Device) returned after (~626 tok)
- `invoke_element.dart` — Declares InvokeElement (~373 tok)
- `node_state.dart` — Declares NodeState (~108 tok)
- `status.dart` — Declares Status (~74 tok)

## lib/src/tlv/

- `element.dart` — Declares Element (~278 tok)
- `tag.dart` — 此文件由kotlin tags.kt 使用ai转成dart (~1366 tok)
- `tlv_reader.dart` — 此文件由kotlin TlvReader.kt 使用ai转成dart (~2443 tok)
- `tlv_types.dart` — Type: encode, extractSize, encodeSize, encode (~1131 tok)
- `tlv_writer.dart` — 此文件由kotlin TlvWriter.kt 使用ai转成dart (~1479 tok)
- `utils.dart` — / Converts bytes in a Little Endian format into Long integer. (~731 tok)
- `values.dart` — Value: toAny, toAny, toAny, toAny (~1023 tok)
