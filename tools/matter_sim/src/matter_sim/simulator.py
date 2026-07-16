from __future__ import annotations

import os
import re
import shutil
import subprocess
from pathlib import Path

from .config import DEFAULT_DISCRIMINATOR, DEFAULT_PASSCODE, MatterSimConfig, default_config
from .payload import default_codes


def run_simulator(
    config: MatterSimConfig | None = None,
    *,
    ble: bool = False,
    factory_reset: bool = False,
    discriminator: int = DEFAULT_DISCRIMINATOR,
    passcode: int = DEFAULT_PASSCODE,
) -> int:
    cfg = config or default_config()
    if not cfg.binary.exists():
        raise SystemExit(
            f"Simulator binary not found: {cfg.binary}\n"
            "Run `matter-sim setup` on the Ubuntu host first."
        )

    if factory_reset:
        reset_storage()

    args = [
        str(cfg.binary),
        "--discriminator",
        str(discriminator),
        "--passcode",
        str(passcode),
    ]
    if ble:
        args.extend(["--ble-controller", "0", "--wifi"])

    codes = default_codes()
    if discriminator == codes.discriminator and passcode == codes.passcode:
        _print_codes(codes.qr_code, codes.manual_code)
    else:
        print("Watch the simulator log for SetupQRCode and Manual pairing code.")

    process = subprocess.Popen(
        args,
        cwd=cfg.chip_dir,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        bufsize=1,
    )
    assert process.stdout is not None
    qr_seen = False
    manual_seen = False
    for line in process.stdout:
        print(line, end="")
        if not qr_seen:
            qr = _find_qr(line)
            if qr:
                qr_seen = True
                print(f"\nMatter QR code: {qr}\n")
        if not manual_seen:
            manual = _find_manual(line)
            if manual:
                manual_seen = True
                print(f"\nMatter manual code: {manual}\n")
    return process.wait()


def reset_storage() -> None:
    tmp = Path(os.environ.get("TMPDIR", "/tmp"))
    for path in tmp.glob("chip_*"):
        if path.is_dir():
            shutil.rmtree(path, ignore_errors=True)
        else:
            path.unlink(missing_ok=True)
    for path in tmp.glob("chip-*"):
        if path.is_dir():
            shutil.rmtree(path, ignore_errors=True)
        else:
            path.unlink(missing_ok=True)


def _print_codes(qr_code: str, manual_code: str) -> None:
    print("")
    print("=" * 72)
    print("Matter simulator onboarding")
    print(f"QR code:      {qr_code}")
    print(f"Manual code:  {manual_code}")
    print("=" * 72)
    print("")


def _find_qr(line: str) -> str | None:
    match = re.search(r"(MT:[A-Z0-9.\-]+)", line)
    return match.group(1) if match else None


def _find_manual(line: str) -> str | None:
    match = re.search(r"\b(\d{11})\b", line)
    return match.group(1) if match else None
