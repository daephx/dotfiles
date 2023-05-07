#!/usr/bin/env sh

# Default Editor:
# Conditionally set the default visual editor
# Provide a list of editor programs in order of priority first
# Define conditions where by that editor should be selected
#
# Such as, making neovim-remote the default visual editor
# when shell is instantiated from inside a neovim terminal buffer.

_emacs() {
  VISUAL="emacsclient -c"
  # Initialize emacs daemon if not running
  if ! emacsclient -e 0 > /dev/null; then
    emacs --daemon > /dev/null
  fi
}

# _nvim() {
#   VISUAL="nvim" # Set default
#   [ -n "$NVIM" ] && {
#     VISUAL="nvim --server \$NVIM --remote-tab"
#     # Use neovim-remote if available
#     if command -v nvr >/dev/null; then
#       VISUAL="nvr -cc '1windo e'"
#       GIT_EDITOR="nvr -cc 'top sp' --remote-wait"
#     fi
#   }
# }

_nvim() {
  VISUAL="nvim" # Set default
  GIT_EDITOR="nvim --cmd 'let g:unception_block_while_host_edits=1'"
  export PATH="$PATH:$XDG_DATA_HOME/nvim/mason/bin"
}

editor() {
  # Define editor list if no argument supplied
  [ $# -eq 0 ] && set -- nvim vim nano
  # Loop available arguments
  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array
    # Skip apps that are not in PATH
    command -v "$cmd" > /dev/null || continue
    case "$cmd" in
      nvim) _nvim ;;
      emacs) _emacs ;;
      nano) VISUAL="nano" ;;
      vi*) VISUAL=$(if command -v vim > /dev/null; then echo "vim"; else echo "vi"; fi) ;;
      *?) printf "Unknown editor selected\n" ;;
    esac
    # Break if visual is set
    [ -n "$VISUAL" ] && break
  done
}

# Unset variables
# Ensure a clean state for all applicable environment variables
unset EDITOR
unset GIT_EDITOR
unset VISUAL

# Overrides for specific terminal programs
# Example: prefer to work within vscode from the integrated terminal
case "$TERM_PROGRAM" in
  vscode) VISUAL="code -w" ;;
  *) editor "$@" ;;
esac

# Overrides for SSH
# Preferred editor for remote sessions
[ -n "$SSH_CONNECTION" ] && VISUAL='vim'

# Override for Vim terminal
[ -n "$VIM_TERMINAL" ] && VISUAL="vim"

# Assign variables to themselves or visual
EDITOR="${VISUAL}"
GIT_EDITOR="${GIT_EDITOR:-$VISUAL}"

# Export variables
export EDITOR
export GIT_EDITOR
export VISUAL
