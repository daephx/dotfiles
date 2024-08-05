# node.js: javascript interpreter and package manager
# shellcheck disable=SC1091
# shellcheck shell=bash

# Set node package manager config file path.
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/npmrc"

# Add npm/bin to PATH.
if [ -f "$NPM_CONFIG_USERCONFIG" ]; then
  PATH="${PATH:+${PATH}:}${XDG_DATA_HOME:-$HOME/.local/share}/npm/bin"
fi
