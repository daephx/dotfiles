# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

# XDG base directory specifications
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_STATE_HOME="$HOME/.local/state"

# $XDG_RUNTIME_DIR should be set by the system. Its access mode MUST be 0700

# Unofficial XDG, extended specifications
# These are not standardized but are useful and common
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_LIB_HOME="$HOME/.local/lib"
