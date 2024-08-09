#!/usr/bin/env bash
# Installer script for distrobox
REPO_URL="https://github.com/89luca89/distrobox.git"
INSTALL_DIR="/tmp/distrobox"
LATEST=$(git ls-remote --tags --refs $REPO_URL | tail -n1 | cut -d/ -f3)

echo "Cloning repository: $REPO_URL"
echo ""
echo "  Release tag:  $LATEST"
echo "  Install path: $INSTALL_DIR"
echo ""

# Clone latest repository version
if [ ! -d "$INSTALL_DIR" ]; then
  echo "Cloning repository..."
  git clone --depth 1 $REPO_URL --single-branch --branch "$LATEST" \
    -c advice.detachedHead=false "$INSTALL_DIR"
else
  HEAD=$(git -C "$INSTALL_DIR" rev-list --tags --max-count=1)
  CURRENT=$(git -C "$INSTALL_DIR" describe --tags "$HEAD")
  if [ "$CURRENT" = "$LATEST" ]; then
    echo "Repository is already up-to-date!"
    exit 0
  else
    echo "Updating repository..."
    git -C "$INSTALL_DIR" fetch --depth 1 origin tag "$LATEST"
    git -C "$INSTALL_DIR" switch --detach "$LATEST"
  fi
fi

# Run installation script
"$INSTALL_DIR"/install
