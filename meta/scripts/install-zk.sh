#!/bin/bash

# Verify dependencies
deps=(git go make)
for dep in "${deps[@]}"; do
  if ! command -v "$dep" > /dev/null; then
    echo "A working $dep installtion is required"
    exit 1
  fi
done

sudo apt-get install build-essential g++ flex bison gperf ruby perl \
  libsqlite3-dev libfontconfig1-dev libicu-dev libfreetype6 libssl-dev \
  libpng-dev libjpeg-dev libx11-dev libxext-dev -y

pushd /tmp/ || exit

git clone https://github.com/mickael-menu/zk.git
pushd zk || exit
make install

# TODO: Acquire latest binary from tags
# curl -LO https://github.com/mickael-menu/zk/releases/download/v0.9.0/zk-v0.9.0-linux-amd64.tar.gz
# tar -xf zk-v0.9.0-linux-amd64.tar.gz

popd || exit
