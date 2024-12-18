#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/junegunn/fzf.git"
INSTALL_DIR="${XDG_SRC_HOME:-$HOME/.local/src}/fzf"

# Ensure parent directory path exists
mkdir -p "$(dirname "$INSTALL_DIR")" > /dev/null

# Clone latest repository version
if [ ! -d "$INSTALL_DIR" ]; then
  git clone --depth 1 $REPO_URL "$INSTALL_DIR"
else
  branch=$(git -C "$INSTALL_DIR" rev-parse --abbrev-ref origin/HEAD | cut -c8-)
  echo "Repository already exists: Updating origin/$branch"
  git -C "$INSTALL_DIR" pull origin "$branch"
fi

# Run installation script
"$INSTALL_DIR"/install --bin
