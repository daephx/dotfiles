# ~/.zshrc: executed by zsh(1) for non-login shells.
# shellcheck shell=zsh
# shellcheck disable=SC1090
# shellcheck disable=SC1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# profile loading timer init
integer t0=$(($(date +%s%N)/1000000))

# Source shell configurations
[ -f ~/.environment ] && source ~/.environment
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases

# Set history file if not exists
export HISTFILE="$XDG_STATE_HOME/zsh_history"

### Options ###

setopt GLOB_COMPLETE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt MENU_COMPLETE
setopt appendhistory
setopt interactive_comments
setopt no_list_ambiguous
setopt noautoremoveslash
setopt share_history
unsetopt BEEP
unsetopt EXTENDED_HISTORY

stty start undef # Disable Ctrl-q closing terminal
stty stop undef # Disable Ctrl-s to freeze terminal.

### Completions ###

autoload -Uz compinit
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zccompdump"
_comp_options+=(globdots) # Include hidden files.

### Plugins ###

plugins=(
  Aloxaf/fzf-tab
  MenkeTechnologies/zsh-dotnet-completion
  MichaelAquilina/zsh-autoswitch-virtualenv
  chitoku-k/fzf-zsh-completions
  zsh-users/zsh-autosuggestions
)

# Source minimal plugin manager.
# Plugin list must be defined beforehand.
[ -f "$ZDOTDIR/zplugin.zsh" ] && source "$ZDOTDIR/zplugin.zsh"

### Styles ###

zle_highlight=('paste:none')

## case-insensitive (uppercase from lowercase) completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select

# Tab completion colors
# zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=16;5;244;2"
zstyle ':completion:*:options' list-colors '=^(-- *)=34'

autoload -Uz colors && colors


### Bindings ###

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "\e" kill-whole-line

bindkey "^j" down-line-or-beginning-search # Down
bindkey "^k" up-line-or-beginning-search   # Up
bindkey "^n" down-line-or-beginning-search # Down
bindkey "^p" up-line-or-beginning-search   # Up

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search


### Complete ###

# Source dynamic config contents from ~/.zshrc.d/*.zsh
for file in "${ZDOTDIR:-$HOME/.config/zsh}"/zshrc.d/*.zsh; do
  [[ -f "${file}" ]] && source "${file}"
done

# Output startup time
function {
  local -i t1 startup
  t1=$(($(date +%s%N)/1000000))
  startup=$(( t1 - t0 ))
  [[ $startup -gt 1 ]] && print "Loading shell profile took: ${startup}ms"
}
unset t0
