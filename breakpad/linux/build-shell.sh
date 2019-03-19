#!/usr/bin/env bash
###
# Breakpad
###
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

cd ../premake

premake5 gmake
make verbose=1
