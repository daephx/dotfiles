#!/usr/bin/env sh
# Shell History Configuration: Customize how the shell command history is managed.

# Set the number of commands to save in memory and to the history file
export HISTSIZE=10000
export HISTFILESIZE=100000
export SAVEHIST=10000

# Configure history behavior and ignored commands
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:ll:la:lc:lt:cd:gt:up:todo:exit:clear:cls:hist:history'
