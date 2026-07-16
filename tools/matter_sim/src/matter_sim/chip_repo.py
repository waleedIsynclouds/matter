from __future__ import annotations

import subprocess
from pathlib import Path

from .config import MatterSimConfig, default_config


def run_setup(config: MatterSimConfig | None = None, *, force_build: bool = False) -> None:
    cfg = config or default_config()
    _require_command("git")

    if not (cfg.chip_dir / ".git").exists():
        cfg.chip_dir.parent.mkdir(parents=True, exist_ok=True)
        subprocess.run(
            ["git", "clone", "--recurse-submodules", cfg.chip_repo, str(cfg.chip_dir)],
            check=True,
        )

    _run_in_chip(cfg, "git submodule update --init --recursive")

    if not cfg.binary.exists() or force_build:
        _run_in_chip(
            cfg,
            "./scripts/bootstrap.sh && "
            "source scripts/activate.sh && "
            "./scripts/examples/gn_build_example.sh "
            "examples/all-clusters-app/linux out/linux-all-clusters-app",
        )
    else:
        print(f"Simulator already built: {cfg.binary}")


def _run_in_chip(config: MatterSimConfig, command: str) -> None:
    subprocess.run(["bash", "-lc", command], cwd=config.chip_dir, check=True)


def _require_command(command: str) -> None:
    try:
        subprocess.run([command, "--version"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
    except (FileNotFoundError, subprocess.CalledProcessError) as exc:
        raise SystemExit(f"{command} is required. Install it first on the Ubuntu host.") from exc
