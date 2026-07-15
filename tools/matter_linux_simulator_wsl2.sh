#!/usr/bin/env bash
set -euo pipefail

CHIP_DIR="${CHIP_DIR:-$HOME/connectedhomeip}"
CHIP_REPO="${CHIP_REPO:-https://github.com/project-chip/connectedhomeip.git}"
CHIP_EXAMPLE="${CHIP_EXAMPLE:-all-clusters-app}"
BUILD_DIR="$CHIP_DIR/out/linux-$CHIP_EXAMPLE"

if ! command -v git >/dev/null 2>&1; then
  echo "git is required. Install it with: sudo apt update && sudo apt install -y git"
  exit 1
fi

if [ ! -d "$CHIP_DIR/.git" ]; then
  git clone --recurse-submodules "$CHIP_REPO" "$CHIP_DIR"
fi

cd "$CHIP_DIR"
git submodule update --init --recursive

if [ -f scripts/bootstrap.sh ]; then
  ./scripts/bootstrap.sh
fi

# shellcheck disable=SC1091
source scripts/activate.sh

case "$CHIP_EXAMPLE" in
  all-clusters-app)
    ./scripts/examples/gn_build_example.sh examples/all-clusters-app/linux "$BUILD_DIR"
    exec "$BUILD_DIR/chip-all-clusters-app" --discriminator 3840 --passcode 20202021
    ;;
  placeholder)
    ./scripts/examples/gn_build_example.sh examples/placeholder/linux "$BUILD_DIR"
    exec "$BUILD_DIR/chip-placeholder-app" --discriminator 3840 --passcode 20202021
    ;;
  *)
    echo "Unsupported CHIP_EXAMPLE=$CHIP_EXAMPLE"
    echo "Use CHIP_EXAMPLE=all-clusters-app or CHIP_EXAMPLE=placeholder"
    exit 1
    ;;
esac
