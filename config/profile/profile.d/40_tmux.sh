# tmux: Auto-launch tmux on shell login.
# shellcheck shell=bash
#
# Call this function at the end of your rc file to auto-start a tmux session.
# Multiple guard clauses ensure tmux doesn't attach in specific situations,
# such as missing dependencies or protecting against nested sessions.
#
# WARN: Load all desired environment variables before this function.
# Otherwise, tmux commands like run-shell won't access those values.

__tmux_start() {
  [ ! -x "$(command -v tmux)" ] && return # Exit if tmux is not installed
  [ -n "$TMUX" ] && return                # Exit if tmux is already running
  [ -n "$SSH_CLIENT" ] && return          # Exit if within an SSH session
  [ -n "$SSH_TTY" ] && return             # Exit if within an SSH session
  [ -n "$VIM" ] && return                 # Exit if within a vim session
  [ -n "$NVIM" ] && return                # Exit if within a neovim session

  [[ "$TERM" =~ screen ]] && return # Exit if TERM type contains: screen
  [[ "$TERM" =~ tmux ]] && return   # Exit if TERM type contains: tmux

  # Create or attach to the default tmux session
  exec tmux new-session -A -s main
}
