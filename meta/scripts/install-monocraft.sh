#!/usr/bin/env bash

set -e

FONTS="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
[ -d "$FONTS" ] || mkdir -p "$FONTS"

echo "downloading font: monocraft..."
url="https://github.com/IdreesInc/Monocraft/releases/latest/download/Monocraft-nerd-fonts-patched.ttf"
dir="$FONTS/Monocraft"
mkdir -p "$dir"
pushd "$dir" || exit
curl -LO "$url"
popd

echo "rebuilding font-cache..."
fc-cache -fv
echo "done!"
