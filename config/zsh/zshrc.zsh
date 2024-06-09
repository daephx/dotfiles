# zshrc: executed by zsh(1) for non-login shells.
# shellcheck disable=SC1090
# shellcheck disable=SC1091
# shellcheck shell=zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Start profile startup timer
integer t0=$(($(date +%s%N)/1000000))

# Set history file if not exists
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh_history"

### Options ###

# Names are case insensitive and underscores are ignored.
# https://zsh.sourceforge.io/Doc/Release/Options.html

setopt GLOB_COMPLETE          # Enable glob matching for competition.
setopt HIST_APPEND            # Append new commands to histfile.
setopt HIST_EXPIRE_DUPS_FIRST # Delete dupes when histfile exceeds histsize.
setopt HIST_FIND_NO_DUPS      # Don't display duplicates when searching histfile.
setopt HIST_IGNORE_ALL_DUPS   # Overwrite duplicate commands in histfile.
setopt HIST_IGNORE_DUPS       # Ignore duplicated commands history list.
setopt HIST_IGNORE_SPACE      # Ignore commands that start with space.
setopt HIST_SAVE_NO_DUPS      # Ignore duplicates when saving to histfile.
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive shells.
setopt SHARE_HISTORY          # Append and imports commands from histfile.
unsetopt AUTO_REMOVE_SLASH    # Remove completed slash after delimiter character.
unsetopt BEEP                 # Turn off terminal bells.
unsetopt EXTENDED_HISTORY     # Save command timestamps to histfile.
unsetopt LIST_AMBIGUOUS       # Auto-listing behaviour only works when nothing would be inserted.
unsetopt MENU_COMPLETE        # Do not auto select the first completion entry.

### Plugins ###

# Zap: a minimal zsh plugin manager
# https://github.com/zap-zsh/zap
ZAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zap"
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
plug 'zsh-users/zsh-autosuggestions'
plug 'zsh-users/zsh-completions'
plug 'zsh-users/zsh-syntax-highlighting'

### Source ###

# Dynamically source user configurations
for file in "$XDG_CONFIG_HOME"/profile.d/*.sh; do
  source "$file"
done

# Zshrc library
source "$ZDOTDIR/aliases.zsh"
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
