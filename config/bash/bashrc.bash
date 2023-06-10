# bashrc: executed by bash(1) for non-login shells.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck shell=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Dynamically source user configurations
for file in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
  source "$file"
done

# Set history file path
export HISTFILE="$XDG_STATE_HOME/bash_history"

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -u lithist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
