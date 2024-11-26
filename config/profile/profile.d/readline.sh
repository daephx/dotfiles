#!/usr/bin/env sh
# GNU Readline: configure input settings

# Use XDG_CONFIG_HOME or fallback to $HOME/.config for the inputrc path
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
