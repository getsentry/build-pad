FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends git python curl ca-certificates

# Install depot_tools
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /opt/depot_tools
ENV PATH=$PATH:/opt/depot_tools

# Initial checkout
RUN mkdir -p /work/crashpad \
  && cd /work/crashpad \
  && fetch crashpad

RUN apt-get install -y clang

# Build crashpad
RUN cd /work/crashpad/crashpad \
  && gn gen out/Default \
  && ninja -C out/Default
