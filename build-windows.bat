@echo on

REM Install depot_tools
if not exist depot_tools (
  git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
) else (
  pushd depot_tools
  git pull -r
  popd
)

set PATH=%PATH%;%CD%\depot_tools

REM Checkout and sync crashpad
if exist crashpad (
  cd crashpad
  git pull -r
  gclient sync
) else (
  fetch crashpad
  cd crashpad
  git checkout master
)

REM Build crashpad
gn gen out\Default
ninja -C out\Default
