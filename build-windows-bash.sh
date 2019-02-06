#!/usr/bin/env sh
set -eux

mkdir build
cd build

git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

export PATH="$(pwd)/depot_tools:$PATH"

fetch.bat crashpad
cd crashpad
git checkout master

# Check Python
which python
python -V

# Build crashpad
gn.bat gen out/Default
ninja.exe -C out/Default
