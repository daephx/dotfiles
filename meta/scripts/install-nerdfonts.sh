#!/usr/bin/env bash

set -e

# Define the base GitHub repository URL and the fonts directory
REPO="ryanoasis/nerd-fonts"
API_URL="https://api.github.com/repos/$REPO/releases/latest"
BASE_URL="https://github.com/$REPO/releases/latest"
FONTS="${XDG_DATA_HOME:-$HOME/.local/share}/fonts"

# Create the fonts directory if it doesn't exist
[ -d "$FONTS" ] || mkdir -p "$FONTS"

# Check if a list of font names was provided as an argument
if [ $# -gt 0 ]; then
  # Use the provided font names
  selection=("$@")
else

  # Print the action being performed
  echo "Grabbing release assets from: $REPO"

  # Fetch the list of .tar.xz assets and extract their names
  release_assets=$(
    curl -s \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      "$API_URL" \
      | jq -r '.assets[] | select(.name | endswith(".tar.xz")) | .name' \
      | awk -F. '{print $1}'
  )

  # Use a while loop to read each line from fzf output
  selection=()
  while read -r line; do
    selection+=("$line")
  done < <(echo "$release_assets" | fzf --ansi --multi --no-sort)

  # Exit the script if no fonts were selected (e.g., user pressed Ctrl-C)
  if [ ${#selection[@]} -eq 0 ]; then
    echo "No fonts selected. Exiting."
    exit 1
  fi
fi

# Create temporary directory for downloads
pushd "$(mktemp -d)" > /dev/null || exit

# Now loop over the array
for font_name in "${selection[@]}"; do
  archive_name="${font_name}.tar.xz"
  download_url="$BASE_URL/download/${archive_name}"

  echo "Downloading: $font_name | $download_url"
  curl -LO "$download_url"

  # Remove old directory and extract archive to $FONTS directory
  [ -d "$font_name" ] && rm -rf "$font_name"
  tar xf "$archive_name" --one-top-level="$font_name" -C "$FONTS"
done

# Exit the temp directory
popd > /dev/null || exit

# Refresh the font cache to recognize the newly installed fonts
echo "Rebuilding font cache..."
fc-cache -fv
echo "Done!"
