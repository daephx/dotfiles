#!/usr/bin/env sh
# GTK2: Configuration for GTK+ 2.0 applications.

# Change GTK2 configuration directory
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc"
