#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

MSBUILD="/c/Program Files (x86)/Microsoft Visual Studio/2017/Enterprise/MSBuild/15.0/Bin/MSBuild.exe"

if [[ "${BUILD_ARCH:-}" == "i686" ]]; then
    PLATFORM="x86"
else
    PLATFORM="x64"
fi

"$MSBUILD" BreakpadTools.sln //m //p:Configuration=Release //p:Platform=$PLATFORM //t:Clean,Build

find .
