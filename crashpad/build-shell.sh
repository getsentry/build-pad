#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

. vars.sh

cd build/crashpad

if [[ "${BUILD_ARCH:-}" == "i686" ]]; then
    PLATFORM="x86"
else
    PLATFORM="x64"
fi

# Check Python
which python
python -V

# Build crashpad
OUT_DIR=out/Default
mkdir -p $OUT_DIR
cp $SCRIPT_DIR/args/args.gn $OUT_DIR
echo "target_cpu = \"${PLATFORM}\"" >> $OUT_DIR/args.gn

$GN_CMD gen "$OUT_DIR"
$NINJA_CMD -C "$OUT_DIR" -v
