skip_global_compinit=1

export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_LOCAL_HOME="$HOME/.local"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# the path to your zsh config, default: '~/.config/zsh'
export ZDOTDIR="$XDG_CONFIG_HOME/zsh/"

# ZSH config dir containing additional configs to be sourced
# Rewrite this if the configs are read from somewhere else
export ZSHCONFD="$XDG_CONFIG_HOME/zsh/.zshrc.d"

# vim config
export MYVIMRC='$XDG_CONFIG_HOME/vim/init.vim' # or any other location you want
export VIMINIT='source $MYVIMRC'

# Python startup file, basic repl customization.
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc"