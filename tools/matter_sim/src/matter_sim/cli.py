from __future__ import annotations

import argparse

from .chip_repo import run_setup
from .config import DEFAULT_DISCRIMINATOR, DEFAULT_PASSCODE, default_config
from .payload import decode_code, generate_codes
from .simulator import run_simulator
from .verify import run_verify


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(prog="matter-sim")
    parser.add_argument("--chip-dir", help="Path to the connectedhomeip checkout.")
    subparsers = parser.add_subparsers(dest="command", required=True)

    setup = subparsers.add_parser("setup", help="Clone, bootstrap, and build chip-all-clusters-app.")
    setup.add_argument("--force-build", action="store_true", help="Rebuild even if the binary already exists.")

    run = subparsers.add_parser("run", help="Run the Matter all-clusters simulator.")
    run.add_argument("--ble", action="store_true", help="Advertise over BLE using hci0 and accept Wi-Fi provisioning.")
    run.add_argument("--factory-reset", action="store_true", help="Remove /tmp/chip_* storage before launch.")
    run.add_argument("--discriminator", type=int, default=DEFAULT_DISCRIMINATOR)
    run.add_argument("--passcode", type=int, default=DEFAULT_PASSCODE)

    gen = subparsers.add_parser("gen-code", help="Generate onboarding QR and manual pairing codes.")
    gen.add_argument("--discriminator", type=int, default=DEFAULT_DISCRIMINATOR)
    gen.add_argument("--passcode", type=int, default=DEFAULT_PASSCODE)
    gen.add_argument("--vendor-id", type=int, default=0)
    gen.add_argument("--product-id", type=int, default=0)
    gen.add_argument("--discovery", default="on-network", choices=["on-network", "ble", "soft-ap"])

    decode = subparsers.add_parser("decode-code", help="Decode a known onboarding code.")
    decode.add_argument("code")

    subparsers.add_parser("verify", help="Explain independent chip-repl verification.")

    args = parser.parse_args(argv)
    config = default_config(args.chip_dir)

    if args.command == "setup":
        run_setup(config, force_build=args.force_build)
        return 0
    if args.command == "run":
        return run_simulator(
            config,
            ble=args.ble,
            factory_reset=args.factory_reset,
            discriminator=args.discriminator,
            passcode=args.passcode,
        )
    if args.command == "gen-code":
        codes = generate_codes(
            discriminator=args.discriminator,
            passcode=args.passcode,
            vendor_id=args.vendor_id,
            product_id=args.product_id,
            discovery=args.discovery,
            config=config,
        )
        _print_codes(codes)
        return 0
    if args.command == "decode-code":
        _print_codes(decode_code(args.code, config=config))
        return 0
    if args.command == "verify":
        run_verify()
    return 1


def _print_codes(codes) -> None:
    print(f"QR code:        {codes.qr_code}")
    print(f"Manual code:    {codes.manual_code}")
    print(f"Discriminator:  {codes.discriminator}")
    print(f"Passcode:       {codes.passcode}")
    print(f"Vendor ID:      {codes.vendor_id}")
    print(f"Product ID:     {codes.product_id}")
    print(f"Discovery:      {codes.discovery}")
