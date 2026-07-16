from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

DEFAULT_DISCRIMINATOR = 3840
DEFAULT_PASSCODE = 20202021
DEFAULT_VENDOR_ID = 0
DEFAULT_PRODUCT_ID = 0
DEFAULT_QR_CODE = "MT:-24J0AFN00KA0648G00"
DEFAULT_MANUAL_CODE = "34970112332"
DEFAULT_CHIP_REPO = "https://github.com/project-chip/connectedhomeip.git"


@dataclass(frozen=True)
class MatterSimConfig:
    chip_dir: Path
    chip_repo: str = DEFAULT_CHIP_REPO
    build_dir_name: str = "linux-all-clusters-app"

    @property
    def build_dir(self) -> Path:
        return self.chip_dir / "out" / self.build_dir_name

    @property
    def binary(self) -> Path:
        return self.build_dir / "chip-all-clusters-app"

    @property
    def payload_script(self) -> Path:
        return self.chip_dir / "src" / "setup_payload" / "generate_setup_payload.py"


def default_config(chip_dir: str | None = None) -> MatterSimConfig:
    configured = chip_dir or os.environ.get("CHIP_DIR")
    path = Path(configured).expanduser() if configured else Path.home() / "connectedhomeip"
    return MatterSimConfig(chip_dir=path)
