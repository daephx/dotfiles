#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/b3nj5m1n/xdg-ninja.git"
INSTALL_DIR="${XDG_SRC_HOME:-$HOME/.local/src}/xdg-ninja"
BIN_DIR="${XDG_LOCAL_HOME:-$HOME/.local/}/bin"

# Ensure parent directory path exists
mkdir -p "$BIN_DIR" > /dev/null
mkdir -p "$(dirname "$INSTALL_DIR")" > /dev/null

# Clone latest repository version
if [ ! -d "$INSTALL_DIR" ]; then
  git clone --depth 1 $REPO_URL "$INSTALL_DIR"
else
  branch=$(git -C "$INSTALL_DIR" rev-parse --abbrev-ref origin/HEAD | cut -c8-)
  echo "Repository already exists: Updating origin/$branch"
  git -C "$INSTALL_DIR" pull origin "$branch"
fi

# Create symbolic link to script
ln -sfn "$INSTALL_DIR/xdg-ninja.sh" "$BIN_DIR/xdg-ninja"
