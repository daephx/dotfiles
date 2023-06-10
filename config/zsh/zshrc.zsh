# ~/.zshrc: executed by zsh(1) for non-login shells.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck shell=zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# profile loading timer init
integer t0=$(($(date +%s%N)/1000000))

# Set history file if not exists
HISTFILE="$XDG_STATE_HOME/zsh/history"


### Options ###

# Enable
setopt GLOB_COMPLETE # enable glob matching for competition
setopt HIST_APPEND # append new commands to histfile
setopt HIST_EXPIRE_DUPS_FIRST # delete dupes when histfile exceeds histsize
setopt HIST_FIND_NO_DUPS # don't display duplicates when searching histfile
setopt HIST_IGNORE_ALL_DUPS # overwrite duplicate commands in histfile
setopt HIST_IGNORE_DUPS # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE # ignore commands that start with space
setopt HIST_SAVE_NO_DUPS # ignore duplicates when saving to histfile
setopt INTERACTIVE_COMMENTS # allow comments in interactive shells
setopt SHARE_HISTORY # append and imports commands from histfile

# Disable
unsetopt AUTO_REMOVE_SLASH # remove completed slash after delimiter character
unsetopt BEEP # turn off terminal bells
unsetopt EXTENDED_HISTORY # save command timestamps to histfile
unsetopt LIST_AMBIGUOUS
unsetopt MENU_COMPLETE # do not auto select the first completion entry


### Plugins ###

# Zap: a minimal zsh plugin manager
# https://github.com/zap-zsh/zap
ZAP_DIR="$XDG_DATA_HOME/zap"
[ -f "$ZAP_DIR/zap.zsh" ] && source "$ZAP_DIR/zap.zsh" || {
  git clone --depth 1 -b "master" "https://github.com/zap-zsh/zap.git" "$ZAP_DIR" > /dev/null 2>&1 || {
    echo "E: Failed to install Zap"
  }
}

# Initialize plugins
plug 'Aloxaf/fzf-tab'
plug 'MenkeTechnologies/zsh-dotnet-completion'
plug 'MichaelAquilina/zsh-autoswitch-virtualenv'
plug 'chitoku-k/fzf-zsh-completions'
plug 'jeffreytse/zsh-vi-mode'
plug 'zsh-users/zsh-autosuggestions'
plug 'zsh-users/zsh-completions'
plug 'zsh-users/zsh-syntax-highlighting'


### Source ###

# Dynamically source user configurations
for file in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
  source "$file"
done

# Zshrc library
source "$ZDOTDIR/completion.zsh"
source "$ZDOTDIR/bindings.zsh"

# Output startup time
function {
  local -i t1 startup
  t1=$(($(date +%s%N)/1000000))
  startup=$(( t1 - t0 ))
  [[ $startup -gt 1 ]] && print "Loading shell profile took: ${startup}ms"
}
unset t0
