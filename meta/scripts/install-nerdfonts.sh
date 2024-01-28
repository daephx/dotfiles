#!/usr/bin/env bash

set -e

FONTS="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"
[ -d $FONTS ] || mkdir -p "$FONTS"

echo "download nerdfonts..."

pushd "$(mktemp -d)" || exit

for font in "${@:-NerdFontsSymbolsOnly}"; do
  url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz"
  archive=$(basename "$url")
  dir=$($archive | cut -d. -f1)
  echo "$url"
  curl -LO "$url"
  [ -d "$dir" ] && rm -rf "$dir"
  tar xf "$archive" --one-top-level -C "$FONTS"
done

popd || exit

echo "rebuilding font-cache..."
fc-cache -fv
echo "done!"
