#/usr/bin/env bash
set -eux

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPT_DIR

pushd ..
docker build -t getsentry/breakpad-build .
docker run -t -v $(pwd):/work -w /work getsentry/breakpad-build make build-linux-all
