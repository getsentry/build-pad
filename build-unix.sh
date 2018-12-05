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

export PATH="$PATH:$(pwd)/depot_tools"

# Checkout and sync crashpad
if [ -d crashpad ]; then
  cd crashpad
  git pull -r
  gclient sync
else
  fetch crashpad
  cd crashpad
  git checkout master
fi

# Build crashpad
gn gen out/Default
ninja -C out/Default
