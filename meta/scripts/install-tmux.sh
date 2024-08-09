#!/usr/bin/env bash
# Install tmux from source

set -e

# Set required variables
REPO_BRANCH="master"
REPO_URL="https://github.com/tmux/tmux.git"
TEMP_DIR="/tmp/tmux"

# Install build dependencies
# NOTE: Only supports debian based distributions.
sudo apt update && sudo apt install -y \
  automake \
  bison \
  build-essential \
  git \
  libevent-dev \
  libncurses5-dev \
  pkg-config

# Remove old temporary directories
# TODO: If directory exists, attempt to get latest commit instead of deleting.
rm -rf "$TEMP_DIR" 2> /dev/null

# Shallow clone the repository
git clone \
  --depth 1 \
  --single-branch \
  --branch "$REPO_BRANCH" \
  "$REPO_URL" \
  "$TEMP_DIR"

# Enter repo directory
pushd "$TEMP_DIR" || return

# Run build commands
sh autogen.sh
./configure && make
sudo make install

# Exit repo directory
popd
