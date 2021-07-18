skip_global_compinit=1

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_LOCAL_HOME="$HOME/.local"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# Python startup file, basic repl customization.
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc"
