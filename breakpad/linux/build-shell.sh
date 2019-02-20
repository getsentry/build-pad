#!/usr/bin/env bash
###
# Breakpad
###
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

cd ../deps/breakpad

./configure ${BREAKPAD_CONFIGURE_FLAGS:-}
make
