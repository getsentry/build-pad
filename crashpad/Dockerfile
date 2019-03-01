FROM ubuntu:16.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends git python curl ca-certificates zlib1g-dev zip

ENV CLANG_VERSION=6.0
RUN apt-get install -y --no-install-recommends clang-${CLANG_VERSION} binutils

RUN \
  update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${CLANG_VERSION} 100 && \
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${CLANG_VERSION} 100
