#!/usr/bin/env bash

set -e

VERSION=0.16.5
REPO=https://github.com/dandavison/delta
PACKAGE="git-delta_${VERSION}_amd64.deb"
RELEASE="$REPO/releases/download/$VERSION/$PACKAGE"

mkdir -p /tmp/git-delta
pushd /tmp/git-delta
curl -OL $RELEASE
sudo apt install ./$PACKAGE
popd
