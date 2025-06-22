# bashrc: executed by bash(1) for non-login shells.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### Environment ###

# Set history file path
HISTFILE="$XDG_STATE_HOME/bash_history"

# Dynamically source user configurations
for file in "${XDG_CONFIG_HOME:-$HOME/.config}"/profile.d/*.sh; do
  source "$file"
done

### Options ###

shopt -s checkwinsize # Check the window size and update after each command.
shopt -s cmdhist      # Save all lines of a multiple-line commands to history.
shopt -s histappend   # Append to the history file, don't overwrite it.
shopt -u lithist      # Save multi-line commands to history with embedded newlines.
