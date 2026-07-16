# matter_sim

`matter_sim` is a small Python CLI that builds and runs the Matter SDK Linux
`chip-all-clusters-app` so the Flutter example can commission a real Matter
device without buying hardware.

The simulated device is still the real C++ Matter SDK binary. Python owns the
developer workflow: clone/bootstrap/build, launch supervision, factory reset,
and onboarding code checks.

Default onboarding values:

- QR: `MT:-24J0AFN00KA0648G00`
- Manual pairing code: `34970112332`
- Discriminator: `3840`
- Passcode: `20202021`

## Install

On native Ubuntu:

```sh
cd /path/to/matter
python3 -m venv tools/matter_sim/.venv
source tools/matter_sim/.venv/bin/activate
pip install -e tools/matter_sim[test]
```

The first simulator build is slow and disk-heavy. Expect roughly 30-60 minutes
and about 30 GB for the `connectedhomeip` checkout and build output.

## Build the simulator

```sh
matter-sim setup
```

This clones `project-chip/connectedhomeip` into `~/connectedhomeip`, runs
`./scripts/bootstrap.sh`, activates the CHIP environment, and builds:

```text
examples/all-clusters-app/linux -> out/linux-all-clusters-app/chip-all-clusters-app
```

Set a custom checkout location with:

```sh
matter-sim --chip-dir /data/connectedhomeip setup
```

## Run on-network commissioning

```sh
matter-sim run
```

Keep the phone and Ubuntu laptop on the same Wi-Fi/subnet. In the Flutter
example stepper, choose the `onNetwork` transport and paste the manual code or
scan the printed QR code.

Useful checks:

```sh
avahi-browse -r _matterc._udp
sudo ufw allow 5353/udp
sudo ufw allow 5540
```

## Run BLE commissioning

```sh
sudo matter-sim run --ble
```

This appends `--ble-controller 0 --wifi`, so the Linux device advertises over
BlueZ and accepts Wi-Fi credentials provisioned by the Android phone. Use the
`androidBle` transport in the example stepper.

BLE requires a Bluetooth adapter on the Ubuntu machine. If the laptop does not
have one, run the same project on a Raspberry Pi or another Linux box.

## Factory reset between attempts

If the simulator says it is already commissioned, wipe the persisted CHIP test
state before launching:

```sh
matter-sim run --factory-reset
matter-sim run --ble --factory-reset
```

## Generate or decode onboarding codes

Default vector:

```sh
matter-sim gen-code
matter-sim decode-code MT:-24J0AFN00KA0648G00
matter-sim decode-code 34970112332
```

Custom code generation delegates to CHIP's `generate_setup_payload.py`, so run
`matter-sim setup` first:

```sh
matter-sim gen-code --discriminator 3840 --passcode 20202021 --discovery ble
```

Non-default decode uses `chip-tool payload parse-setup-payload` when `chip-tool`
is available on `PATH` or under the `connectedhomeip/out/**/chip-tool` build
tree. The default test vector decodes without CHIP tooling.

Use generated codes to test the Dart/native onboarding parsers:

- `lib/src/onboarding.dart`
- `android/src/main/kotlin/com/tyx/flutter_matter/Onboarding.kt`
- `ios/Classes/Onboarding.m`

## Optional independent verification

`matter-sim verify` documents the next step: build the CHIP Python controller or
use `chip-tool`/`chip-repl` to commission the same simulator and read/write an
attribute independently. If CHIP tooling can read an attribute and the Flutter
example cannot, the bug is in the plugin path rather than the simulated device.

## Tests

```sh
pytest tools/matter_sim/tests
```
