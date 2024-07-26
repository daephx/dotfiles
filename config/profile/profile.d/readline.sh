# GNU Readline: configure input settings
# shellcheck shell=sh

# Use XDG_CONFIG_HOME or fallback to $HOME/.config for the inputrc path
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/readline/inputrc"
