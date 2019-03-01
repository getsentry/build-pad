FROM debian:8

RUN apt-get update \
  && apt-get install -y --no-install-recommends git python curl ca-certificates zlib1g-dev zip

RUN apt-get install -y --no-install-recommends clang-4.0 binutils

RUN \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-4.0 100 && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-4.0 100
