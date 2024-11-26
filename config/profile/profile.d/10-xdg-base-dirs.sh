#!/usr/bin/env sh
# XDG: Follow the XDG Base Directory Specification
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# shellcheck disable=SC2148

# NOTE: $XDG_RUNTIME_DIR should be set by the system.
# Its access mode MUST be 0700 for security purposes.

# Standard XDG base directories
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_STATE_HOME="$HOME/.local/state"

# Unofficial, extended XDG directories (not standardized but commonly used)
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_LIB_HOME="$HOME/.local/lib"
export XDG_SRC_HOME="$HOME/.local/src"
