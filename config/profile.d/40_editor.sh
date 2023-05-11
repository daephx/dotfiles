# editor: Conditionally set users default editor
# assign EDITOR/VISUAL variables based on priority list and context!
# This script will apply a default editor and expose the editor function for
# temporarily overriding the associated variables.
#
# Default editor order: nvim, vim, vi, nano

__editor_emacs() {
  VISUAL="emacsclient -c"
  # Initialize emacs daemon if not running
  if ! emacsclient -e 0 > /dev/null; then
    emacs --daemon > /dev/null
  fi
}

__editor_nvim() {
  VISUAL="nvim"
  PATH="$PATH:$XDG_DATA_HOME/nvim/mason/bin"
  [ -n "$NVIM" ] && {
    VISUAL="nvim --server \$NVIM --remote-tab"
    # Use neovim-remote if available
    if command -v nvr > /dev/null; then
      VISUAL="nvr -cc '1windo e'"
      GIT_EDITOR="nvr -cc 'top sp' --remote-wait"
    else
      printf "\e[031mE\e[0m: Command could not be located: nvr (neovim-remote)\n"
      printf "This is recommended for better integration between nvim terminal and git.\n"
      printf "Install command: 'pip3 install neovim-remote'\n\n"
    fi
  }
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
      emacs) __editor_emacs ;;
      nvim) __editor_nvim ;;
      vi*) VISUAL=$(if command -v vim > /dev/null; then echo "vim"; else echo "vi"; fi) ;;
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
  *) editor "$@" ;;
esac

# Overrides for SSH
# Preferred editor for remote sessions
[ -n "$SSH_CONNECTION" ] && VISUAL="${VISUAL:-vim}"

# Override for Vim terminal
[ -n "$VIM_TERMINAL" ] && VISUAL="vim"

# Assign variables to themselves or visual
EDITOR="${VISUAL}"
GIT_EDITOR="${GIT_EDITOR:-$VISUAL}"

# Export variables
export EDITOR
export GIT_EDITOR
export VISUAL
