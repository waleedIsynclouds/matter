# Cerebrum

> OpenWolf's learning memory. Updated automatically as the AI learns from interactions.
> Do not edit manually unless correcting an error.
> Last updated: 2026-07-12

## User Preferences

<!-- How the user likes things done. Code style, tools, patterns, communication. -->

## Key Learnings

- **Project:** matter (`flutter_matter` v0.0.10) — a low-level Flutter plugin for the Matter smart-home protocol (Android + iOS), published at github.com/Tan-yi-xiong/flutter_matter.
- **Structure:** Dart API in `lib/` (controller, onboarding, BLE, NSD, TLV stack, models, cluster helpers); Android native in Kotlin (`android/src/main/kotlin/com/tyx/flutter_matter/`, uses ChipDeviceController); iOS native in Obj-C/Swift (`ios/Classes/`, wraps a prebuilt `ZGMatter.framework` — a renamed Project CHIP Matter.framework). Demo app in `example/`.
- **Communication:** Flutter MethodChannel (`lib/flutter_matter_method_channel.dart`) with bidirectional calls (native calls back into Dart via `CallbackHandler`).
- **iOS quirk:** requires a Matter App Extension target + shared App Group (`AppGroupId` in Info.plist of both targets); see README steps 2–5. Some iOS source comments are in Chinese.
- **TLV files in `lib/src/tlv/` were AI-converted from the Kotlin originals** (tags.kt, TlvReader.kt, TlvWriter.kt) — noted in their headers.

## Do-Not-Repeat

<!-- Mistakes made and corrected. Each entry prevents the same mistake recurring. -->
<!-- Format: [YYYY-MM-DD] Description of what went wrong and what to do instead. -->

## Decision Log

<!-- Significant technical decisions with rationale. Why X was chosen over Y. -->
- [2026-07-13] Build config target: user's OWN proven stack, not the raw 3.44.3 templates — **Gradle 8.14-all + AGP 8.x (used 8.11.1) + Kotlin 2.3.20**, compileSdk 36, Java 17, minSdk `flutter.minSdkVersion` (24), pubspec env `sdk: ^3.12.0` / `flutter: ">=3.44.0"`, iOS 13.0. User corrected the initial Gradle 9.1.0/AGP 9.0.1 template values — AGP 9 needs Gradle 9 and their apps stay on Gradle 8.14 (they guard with `agpMajor < 9` in their apps). AGP-9-only gradle.properties flags (`android.newDsl`, `android.builtInKotlin`) must NOT be used on AGP 8.
- [2026-07-13] Flutter is NOT on PATH; user manages SDKs with **puro** (`~/.puro/envs/` — default/stable = 3.44.3, master = 3.35.6). Use `~/.puro/envs/default/flutter/bin/flutter` for CLI runs.
- [2026-07-13] In plugin `android/build.gradle`, the `dependencies {}` block was nested inside `android {}` — moved to top level for AGP 9 strict DSL. Kotlin jvmTarget now set via `kotlin { compilerOptions { jvmTarget } }` (kotlinOptions is deprecated in Kotlin 2.x). Example pbxproj has 18.5 deployment targets on the MatterExt extension target — leave those alone.
