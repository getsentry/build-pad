#/usr/bin/env bash
set -eux

docker build -t getsentry/crashpad-build .
docker run -it -v $(pwd):/work -w /work getsentry/crashpad-build bash build-unix.sh
