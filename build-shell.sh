#!/usr/bin/env bash
set -eux

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
$GN_CMD gen out/Default
$NINJA_CMD -C out/Default
