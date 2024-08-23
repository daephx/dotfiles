# python: an interpreted, interactive, object-oriented programming language.
# shellcheck shell=bash

# Exit if neither Python 2 nor Python 3 is installed
[ ! -x "$(command -v python)" ] && [ ! -x "$(command -v python3)" ] && return

# Set Python startup file for REPL customization
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc.py"

# Disable prompt modification for virtual environments
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Exit if not in an interactive shell
[[ $- != *i* ]] && return

# Create shorthand commands for Python and IPython
alias py="python"
alias ipy="ipython"
