# ~/.zshrc: executed by zsh(1) for all user shells.

# Speed up zsh by skipping completion cache
skip_global_compinit=1

# XDG base directory specifications
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Unofficial XDG, extended specifications
# These are not standardized but are useful and common
export XDG_BIN_HOME="$XDG_LOCAL_HOME/bin"
export XDG_LIB_HOME="$XDG_LOCAL_HOME/lib"

# the path to your zsh config, default: '~/.config/zsh'
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Dotfiles locations
export DOTFILES="$HOME/.dotfiles"

# Prevent PATH duplication
typeset -U PATH path

# If you come from bash you might have to change your $PATH.
export PATH="$XDG_LOCAL_HOME/bin:/usr/local/bin:$PATH"
