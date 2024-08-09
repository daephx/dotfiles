#!/usr/bin/env bash

set -e

pushd "$(mktemp -d)"

URL=https://github.com/isacikgoz/tldr/releases/download/v1.0.0-alpha/tldr_1.0.0-alpha_linux_amd64.tar.gz
curl -OL $URL
tar xzf tldr_1.0.0-alpha_linux_amd64.tar.gz
mv tldr "${XDG_LOCAL_HOME:-$HOME/.local}"/bin

popd
