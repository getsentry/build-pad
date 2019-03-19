FROM ubuntu:14.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends git python curl ca-certificates zlib1g-dev build-essential zip

RUN cd /tmp \
  && curl -L "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha13/premake-5.0.0-alpha13-linux.tar.gz" -o downloaded.out \
  && tar xvf ./downloaded.out \
  && chmod +x premake5 \
  && mv premake5 /usr/local/bin
