#!/usr/bin/env bash

# TODO: Detect architecture: amd64, arm

# URL_TEMPLATE="https://github.com/%s/releases/download/latest/%s-%s"
# REPO="naggie/dstask"
# BINARY=""
# ARCH="$(dpkg --print-architecture)"

curl -L "https://github.com/naggie/dstask/releases/download/latest/dstask-linux-amd64" \
  -o "$HOME/.local/bin/dstask"
chmod +x "$HOME/.local/bin/dstask"

curl -L "https://github.com/naggie/dstask/releases/download/latest/dstask-import-linux-amd64" \
  -o "$HOME/.local/bin/dstask-import"
chmod +x "$HOME/.local/bin/dstask-import"
