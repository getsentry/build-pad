#/usr/bin/env bash
set -ex

docker build -t getsentry/crashpad-build .
docker run -it -v $(pwd):/work -w /work getsentry/crashpad-build bash build-linux.sh
