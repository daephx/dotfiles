#!/usr/bin/env sh
# WGet: Set custom configuration and history file.

# Set Wget configuration variables.
export WGETHIST="${XDG_STATE_HOME:-$HOME/.local/share}/wget/history"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"

# Create parent directory for wget history file if not exists.
wget_data_home="$(dirname $WGETHIST)"
[ ! -d "$wget_data_home" ] && mkdir -p "$wget_data_home" >/dev/null

# Unset the environment variable if the file doesn't exist.
# This prevents file not found errors from occuring for commands that use wget.
[ ! -f "$WGETRC" ] && unset WGETRC

# Alias Wget to use custom history file as Wget doesn't support it via env vars.
alias wget="wget --hsts-file \$WGETHIST"
