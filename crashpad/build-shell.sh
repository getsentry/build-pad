#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p build
cd build

# Install depot_tools
if [ -d depot_tools ]; then
  pushd depot_tools
  git pull -r
  popd
else
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
fi

export PATH="$(pwd)/depot_tools:$PATH"

if [ "${AGENT_OS:-}" == "Windows_NT" ]; then
  FETCH_CMD='fetch.bat'
  GN_CMD='gn.bat'
  NINJA_CMD='ninja.exe'
  GCLIENT_CMD='gclient.bat'
else
  FETCH_CMD='fetch'
  GN_CMD='gn'
  NINJA_CMD='ninja'
  GCLIENT_CMD='gclient'
fi

# Checkout and sync crashpad
if [ -d crashpad ]; then
  cd crashpad
  git pull -r
  $GCLIENT_CMD sync
else
  $FETCH_CMD crashpad
  cd crashpad
  git checkout master
fi

# Check Python
which python
python -V

# Build crashpad
OUT_DIR=out/Default
mkdir -p $OUT_DIR
cp $SCRIPT_DIR/args/args.gn $OUT_DIR

$GN_CMD gen "$OUT_DIR"
$NINJA_CMD -C "$OUT_DIR"
