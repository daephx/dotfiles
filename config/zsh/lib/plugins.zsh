#!/usr/bin/env zsh

ZSH_PLUGIN_LIST=() # Active plugin array
ZSH_PLUGIN_DIR="$ZDOTDIR/plugins" # Path to install plugins

# User confirmation
# ARGUMENTS:
#   message string
function zsh_plugin_choice() {
  while true; do
    vared -cp "$1 " ans
    case $ans in
      [Yy]*) break;;
      [Nn]*) return 1;;
      *) echo "Please answer yes or no.";;
    esac
  done
  return 0
}

# Function to source files if they exist
function zsh_add_file() {
  [ -f "$ZDOTDIR/$1" ] && source "$ZDOTDIR/$1"
}

function initialize_plugins() {
  for plugin in "$_plugins[@]"; do
    zsh_add_plugin $plugin
  done
}

function initialize_completions() {
  for completion in "$_completions[@]"; do
    zsh_add_completion $completion
  done
}

function zsh_add_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
    # For plugins
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
      zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
  else
    git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
  fi
}

function zsh_add_completion() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
    # For completions
    completion_file_path=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
    fpath+="$(dirname "${completion_file_path}")"
    zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
  else
    git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
    fpath+=$(ls $ZDOTDIR/plugins/$PLUGIN_NAME/_*)
    [ -f $ZDOTDIR/.zccompdump ] && $ZDOTDIR/.zccompdump
  fi
  completion_file="$(basename "${completion_file_path}")"
  if [ "$2" = true ] && compinit "${completion_file:1}"
}

function zsh_clean_plugins() {
  installed_plugins="$(find . -maxdepth 1 -type d)"
  for plugin in "$installed_plugins[@]"; do
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ ! -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
      # TODO: Traverse plugin directory, remove/disable missing from list
      echo "E: Not implimented"
    fi
  done
}

function zsh_remove_plugin() {
  PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then
    rm -rf "$ZDOTDIR/plugins/$PLUGIN_NAME"
    printf "Uninstalled Plugin: $PLUGIN_NAME\n"
  fi
}
