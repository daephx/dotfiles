skip_global_compinit=1

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# If you come from bash you might have to change your $PATH.
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# the path to your zsh config, default: '~/.config/zsh'
# vim config
export MYVIMRC='$XDG_CONFIG_HOME/vim/init.vim' # or any other location you want
export VIMINIT='source $MYVIMRC'
# Python startup file, basic repl customization.
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc"
