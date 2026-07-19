from __future__ import annotations

import re
import shutil
import subprocess
from dataclasses import dataclass

from .config import (
    DEFAULT_DISCRIMINATOR,
    DEFAULT_MANUAL_CODE,
    DEFAULT_PASSCODE,
    DEFAULT_PRODUCT_ID,
    DEFAULT_QR_CODE,
    DEFAULT_VENDOR_ID,
    MatterSimConfig,
    default_config,
)


@dataclass(frozen=True)
class OnboardingCodes:
    qr_code: str
    manual_code: str
    discriminator: int
    passcode: int
    vendor_id: int = DEFAULT_VENDOR_ID
    product_id: int = DEFAULT_PRODUCT_ID
    discovery: str = "on-network"


def generate_codes(
    *,
    discriminator: int = DEFAULT_DISCRIMINATOR,
    passcode: int = DEFAULT_PASSCODE,
    vendor_id: int = DEFAULT_VENDOR_ID,
    product_id: int = DEFAULT_PRODUCT_ID,
    discovery: str = "on-network",
    config: MatterSimConfig | None = None,
) -> OnboardingCodes:
    if _is_default(discriminator, passcode, vendor_id, product_id, discovery):
        return default_codes()

    cfg = config or default_config()
    if cfg.payload_script.exists():
        return _generate_with_chip(
            cfg,
            discriminator=discriminator,
            passcode=passcode,
            vendor_id=vendor_id,
            product_id=product_id,
            discovery=discovery,
        )

    raise RuntimeError(
        "Custom code generation requires the connectedhomeip checkout. "
        "Run `matter-sim setup` first, or use the default test vector."
    )


def decode_code(code: str, *, config: MatterSimConfig | None = None) -> OnboardingCodes:
    normalized = code.strip()
    if normalized in {DEFAULT_QR_CODE, DEFAULT_MANUAL_CODE}:
        return default_codes()

    cfg = config or default_config()
    chip_tool = _find_chip_tool(cfg)
    if chip_tool:
        return _decode_with_chip_tool(chip_tool, normalized)

    raise RuntimeError(
        "Only the built-in Matter default test vector can be decoded without chip-tool. "
        "Build or install chip-tool, then retry `matter-sim decode-code`."
    )


def default_codes() -> OnboardingCodes:
    return OnboardingCodes(
        qr_code=DEFAULT_QR_CODE,
        manual_code=DEFAULT_MANUAL_CODE,
        discriminator=DEFAULT_DISCRIMINATOR,
        passcode=DEFAULT_PASSCODE,
    )


def _is_default(
    discriminator: int,
    passcode: int,
    vendor_id: int,
    product_id: int,
    discovery: str,
) -> bool:
    return (
        discriminator == DEFAULT_DISCRIMINATOR
        and passcode == DEFAULT_PASSCODE
        and vendor_id == DEFAULT_VENDOR_ID
        and product_id == DEFAULT_PRODUCT_ID
        and discovery in {"on-network", "on_network", "ble"}
    )


def _generate_with_chip(
    config: MatterSimConfig,
    *,
    discriminator: int,
    passcode: int,
    vendor_id: int,
    product_id: int,
    discovery: str,
) -> OnboardingCodes:
    capability = {
        "on-network": "4",
        "on_network": "4",
        "ble": "2",
        "soft-ap": "1",
        "soft_ap": "1",
    }.get(discovery, discovery)
    command = (
        "source scripts/activate.sh && "
        f"python3 {config.payload_script} "
        f"--discriminator {discriminator} "
        f"--setup-pin-code {passcode} "
        f"--vendor-id {vendor_id} "
        f"--product-id {product_id} "
        f"--rendezvous {capability}"
    )
    completed = subprocess.run(
        ["bash", "-lc", command],
        cwd=config.chip_dir,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    qr_code = _extract(r"(MT:[A-Z0-9.\-]+)", completed.stdout)
    manual_code = _extract(r"\b(\d{11})\b", completed.stdout)
    if not qr_code or not manual_code:
        raise RuntimeError(f"Could not parse CHIP payload output:\n{completed.stdout}")
    return OnboardingCodes(
        qr_code=qr_code,
        manual_code=manual_code,
        discriminator=discriminator,
        passcode=passcode,
        vendor_id=vendor_id,
        product_id=product_id,
        discovery=discovery,
    )


def _extract(pattern: str, text: str) -> str | None:
    match = re.search(pattern, text)
    return match.group(1) if match else None


def _find_chip_tool(config: MatterSimConfig) -> str | None:
    from_path = shutil.which("chip-tool")
    if from_path:
        return from_path
    if config.chip_dir.exists():
        for candidate in config.chip_dir.glob("out/**/chip-tool"):
            if candidate.is_file():
                return str(candidate)
    return None


def _decode_with_chip_tool(chip_tool: str, code: str) -> OnboardingCodes:
    completed = subprocess.run(
        [chip_tool, "payload", "parse-setup-payload", code],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    output = completed.stdout
    discriminator = _extract_int(r"discriminator[^0-9]*(\d+)", output)
    passcode = _extract_int(r"(?:setup pin code|setup pincode|passcode)[^0-9]*(\d+)", output)
    vendor_id = _extract_int(r"vendor[^0-9]*(\d+)", output, default=0)
    product_id = _extract_int(r"product[^0-9]*(\d+)", output, default=0)
    if discriminator is None or passcode is None:
        raise RuntimeError(f"Could not parse chip-tool output:\n{output}")
    return OnboardingCodes(
        qr_code=code if code.startswith("MT:") else "",
        manual_code=code if code.isdigit() else "",
        discriminator=discriminator,
        passcode=passcode,
        vendor_id=vendor_id,
        product_id=product_id,
        discovery="chip-tool",
    )


def _extract_int(pattern: str, text: str, *, default: int | None = None) -> int | None:
    match = re.search(pattern, text, flags=re.IGNORECASE)
    return int(match.group(1)) if match else default
