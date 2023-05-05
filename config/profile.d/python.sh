# Python Settings
# Python startup file, basic repl customization.
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"

# Make python look in '~/.local/share/python/lib' for custom modules and packages
export PYTHONPATH="$PYTHONPATH:$XDG_LOCAL_HOME/share/python/lib"
