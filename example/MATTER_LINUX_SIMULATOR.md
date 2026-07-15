# Matter Linux Simulator for the Example App

Use this when you want your laptop to act like a Matter device for testing the
Flutter example without BLE hardware.

## What this tests

- Android commissioning through `ChipDeviceController.pairDeviceWithCode(...)`.
- The example app's "Start on-network simulator" flow.
- Basic post-commissioning reads and commands against a real Matter SDK device
  process.

It does not test Matter-over-BLE commissioning. BLE peripheral simulation from a
Windows laptop is a separate setup and is not required for this path.

## WSL2 setup

Run the helper from Ubuntu on WSL2:

```sh
cd /mnt/d/Waleed/flutter\ projects/matter
bash tools/matter_linux_simulator_wsl2.sh
```

The script clones `project-chip/connectedhomeip` into
`~/connectedhomeip`, installs/builds the Linux example, and runs it. The first
build can take a long time.

When the simulator starts, copy the `SetupQRCode` value or manual pairing code
from its logs.

## App flow

1. Make sure the Android device and WSL2 simulator can reach each other on the
   same LAN.
2. Run the Flutter example on Android.
3. Paste or scan the simulator onboarding code.
4. Enter Wi-Fi credentials if the example asks for them.
5. Tap `Start on-network simulator`.
6. Watch for `onCommissioningStatusUpdate` and
   `onCommissioningComplete(..., errorCode: 0)` in the logs.

If discovery fails, check Windows firewall, WSL2 networking mode, and mDNS
visibility between the phone/emulator and WSL2.

## References

- https://project-chip.github.io/connectedhomeip-doc/guides/simulated_device_linux.html
- https://project-chip.github.io/connectedhomeip-doc/development_controllers/chip-tool/chip_tool_guide.html
