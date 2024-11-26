#!/usr/bin/env sh
# WGet: Set custom configuration and history file.

# Set Wget configuration and history paths.
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export WGETHIST="$XDG_CACHE_HOME/wget/history"

# Alias Wget to use custom history file as Wget doesn't support it via env vars.
alias wget="wget --hsts-file \$WGETHIST"
