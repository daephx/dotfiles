# Ruby: a language focusing on simplicity and productivity
# shellcheck shell=bash

# Exit if Ruby is not installed
[ ! -x "$(command -v ruby)" ] && return

# If the 'gem' command is available
if [ -x "$(command -v gem)" ]; then
  # Add Ruby gem bin directory to PATH
  PATH="${PATH:+${PATH}:}$(ruby -e 'puts Gem.user_dir')/bin"
fi

# If the 'bundle' command is available
if [ -x "$(command -v bundle)" ]; then
  # Set custom directories for Bundler cache, config, and plugins
  export BUNDLE_USER_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}"/bundle
  export BUNDLE_USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"/bundle
  export BUNDLE_USER_PLUGIN="${XDG_DATA_HOME:-$HOME/.local/share}"/bundle
fi
