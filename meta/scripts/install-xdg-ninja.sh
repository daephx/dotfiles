#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/b3nj5m1n/xdg-ninja.git"
INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/xdg-ninja"
BIN_DIR="${XDG_LOCAL_HOME:-$HOME/.local/}/bin"

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
