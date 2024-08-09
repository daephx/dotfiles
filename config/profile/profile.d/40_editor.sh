# editor: Conditionally set users default editor
# assign EDITOR/VISUAL variables based on priority list and context!
# This script will apply a default editor and expose the editor function for
# temporarily overriding the associated variables.
# shellcheck shell=bash
#
# Default editor order: nvim, vim, vi, nano

__editor_init_nvim() {
  VISUAL="nvim"
  PATH="$PATH:$XDG_DATA_HOME/nvim/mason/bin"
  # Use neovim-remote if available
  if [ -n "$NVIM" ] && command -v nvr > /dev/null; then
    GIT_EDITOR="nvr -cc 'top sp' --remote-wait"
    VISUAL="nvr -cc '1windo e'"
  fi
  # shellcheck disable=SC2139
  alias vi="$VISUAL"
}

__editor_init_vim() {
  VISUAL="vim"
  alias vi="vim"
}

__editor_init() {
  # Define editor list if no argument supplied
  [ $# -eq 0 ] && set -- nvim vim nano
  # Loop available arguments
  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array
    # Skip apps that are not in PATH
    command -v "$cmd" > /dev/null || continue
    case "$cmd" in
      nvim) __editor_init_nvim ;;
      vim) __editor_init_vim ;;
      vi) VISUAL="vi" ;;
      nano) VISUAL="nano" ;;
      *?) printf "Unknown editor selected\n" ;;
    esac
    # Break if visual is set
    [ -n "$VISUAL" ] && break
  done
}

# Overrides for specific terminal programs
# Example: prefer to work within vscode from the integrated terminal
case "$TERM_PROGRAM" in
  vscode) VISUAL="code -w" ;;
  *) __editor_init "$@" ;;
esac

# Overrides for SSH
# Preferred editor for remote sessions
[ -n "$SSH_CONNECTION" ] && VISUAL="${VISUAL:-vim}"

# Override for Vim terminal
[ -n "$VIM_TERMINAL" ] && __editor_init:vim

# Export variables
export GIT_EDITOR="${GIT_EDITOR:-$VISUAL}"
export VISUAL
