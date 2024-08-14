# Fzf: A command-line fuzzy finder
# https://github.com/junegunn/fzf
# shellcheck disable=SC1091

# Add fzf/bin directory to PATH
setup_path() {
  local install_dir="${XDG_SRC_HOME:-$HOME/.local/src}/fzf"
  if [[ -d "$install_dir/bin" ]] \
    && [[ ! "$PATH" == *$install_dir/bin* ]]; then
    export PATH="${PATH:+${PATH}:}$install_dir/bin"
  fi
}
setup_path

# Do nothing if application is not available.
[ ! -x "$(command -v fzf)" ] && return

# Initialize fzf shell integrations
[ -n "$BASH_VERSION" ] && eval "$(fzf --bash)"
[ -n "$ZSH_VERSION" ] && eval "$(fzf --zsh)"

# Extra options
export FZF_DEFAULT_COMMAND="rg -uu --files -H"
export FZF_ALT_COMMAND="fd -uu -t f"
export FZF_COMPLETION_TRIGGER="**"
export FZF_DEFAULT_OPTS_FILE"=${XDG_CONFIG_HOME:-$HOME/.config}/fzf/config"

# CTRL-/ | Toggle small preview window to see the full command
# CTRL-Y | Copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
--header 'Press CTRL-Y to copy command into clipboard'
--color header:italic
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--preview 'echo {}' --preview-window up:3:hidden:wrap
"
