#!/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

MSBUILD="/c/Program Files (x86)/Microsoft Visual Studio/2017/Enterprise/MSBuild/15.0/Bin/MSBuild.exe"

"$MSBUILD" BreakpadTools.sln //m //p:Configuration=Release //p:Platform=x64 //t:Clean,Build

# ./crash

find .
