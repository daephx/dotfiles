# python: an interpreted, interactive, object-oriented programming language.
# shellcheck shell=bash

# Exit if neither Python 2 nor Python 3 is installed
[ ! -x "$(command -v python)" ] && [ ! -x "$(command -v python3)" ] && return

# Define user-specific Python library path and create it if it doesn't exist
PYTHON_USER_LIB=${XDG_DATA_HOME:-$HOME/.local/share}/python/lib
[ ! -d "$PYTHON_USER_LIB" ] && mkdir -p "$PYTHON_USER_LIB" &> /dev/null

# Add user library to PYTHONPATH for custom modules and packages
export PYTHONPATH="$PYTHONPATH:$PYTHON_USER_LIB"

# Set Python startup file for REPL customization
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/pythonrc.py"

# Disable prompt modification for virtual environments
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Exit if not in an interactive shell
[[ $- != *i* ]] && return

# Create shorthand commands for Python and IPython
alias py="python"
alias ipy="ipython"
