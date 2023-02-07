# plugins.zsh: minimal function library for managing zsh plugins
# Usage: Define plugins array then source plugin manager script
#
# plugins=(
#   chitoku-k/fzf-zsh-completions
#   zsh-users/zsh-autosuggestions
# )
# source "$ZDOTDIR/plugins.zsh"

# Path to install plugins
ZSH_PLUGIN_DIR="${ZSH_PLUGIN_DIR:-$HOME/.local/share/zsh/plugins}"

# User confirmation
# ARGUMENTS:
#   message string
function _confirm() {
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

# Update plugins from git repository
# ARGUMENTS:
#   string plugin definitions (org/repo)
function zsh_plugin_update() {
  local plugin
  for plugin in "${1:-$plugins[@]}"; do
    local plugin_name=$(echo $plugin | cut -d "/" -f 2)
    local default_branch=$(git -C "$ZSH_PLUGIN_DIR/$plugin_name" rev-parse --abbrev-ref origin/HEAD | cut -d "/" -f 2)
    echo -e "Updaing plugin: $plugin:$default_branch"
    git -C "$ZSH_PLUGIN_DIR/$plugin_name" pull origin $default_branch 1>& /dev/null
  done
}

function zsh_plugin_uninstall() {
  local plugin_name=$(echo $1 | cut -d "/" -f 2)
  local plugin_path="$ZSH_PLUGIN_DIR/$plugin_name"
  if [ -d "$plugin_path" ]; then
    _confirm "Are you sure want to uninstall this plugin? '$plugin_name'"
    rm -rf "$plugin_path"
    printf "Uninstalled plugin: $plugin_path\n"
  fi
}

# WARN: This is dangerous for local-only plugin directories
#       They will be deleted if not defined
#
# Removed installed plugins that are no longer listed in zsh_plugin_initialize
function zsh_plugin_clean() {
  echo "This will remove all plugin directories that are not defined in the \$plugins list."
  _confirm "Are you sure you want to continue? (y/n):"
  echo -e "Scanning installed plugins...\n"
  for installed in $ZSH_PLUGIN_DIR/*; do
    local plugin_dir="$(basename $installed)"
    for plugin in $plugins; do
      local plugin_name="$(echo "$plugin" | cut -d "/" -f 2)"
      # Check if plugin list contains matching directory name
      if [[ "$plugin_name" == "$plugin_dir" ]]; then
        echo -e "  \e[0;32m$plugin\e[0m"
        continue 2 # stop outer loop
      fi
    done
    echo -e "  \e[0;31m$plugin\e[0m"
    rm -rf "$installed"
  done
  echo # final newline
}

# Load all plugins defined in ~/.zshrc
function zsh_plugin_install() {
  local plugin
  for plugin ($plugins); do
    local plugin_name=$(echo "$plugin" | cut -d "/" -f 2)
    local plugin_path="$ZSH_PLUGIN_DIR/$plugin_name"

    # Install plugin repository
    if [[ ! -d "$plugin_path" ]]; then
      echo -e "\e[0;35mInstalling plugin: $plugin\e[0m"
      git clone --depth 1 "https://github.com/$plugin.git" "$plugin_path"
    fi

    # Source plugin files
    source "$plugin_path/"*".plugin.zsh" ||
      source "$plugin_path/$plugin_name.zsh" ||
        echo -e "\e[0;31mplugin not found: '$plugin'\e[0m"

    # Source completion files
    local completion_file_path=$(find "$plugin_path/_"*) 2>/dev/null
    fpath+="$(dirname "$completion_file_path")"
  done
}

# Run install function when sourced
# Make sure the plugins=() array is defined before source
zsh_plugin_install
