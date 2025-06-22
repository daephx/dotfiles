#!/usr/bin/env sh
# GnuPG: The GNU Privacy Guard suite of programs.

# Change GnuPG config directory
export GNUPGHOME="${XDG_CONFIG_HOME:-$HOME/.config}/gnupg"
