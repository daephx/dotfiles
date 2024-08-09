# Emacs configuration: Initializes environment for Emacs editor.
# Last updated by You on 2023-05-05. Refactored to relocate user shell config.

# Exit if Emacs is not installed.
[ ! -x "$(command -v emacs)" ] && return

# Set directories for Emacs and Doom configurations.
export EMACSDIR="$XDG_CONFIG_HOME/emacs"
export DOOMDIR="$XDG_CONFIG_HOME/emacs.doom"

# Add Emacs binary directory to PATH if it exists.
if [ -d "$EMACSDIR/bin" ]; then
  export PATH="$PATH:${EMACSDIR}/bin"
fi

# Define aliases for Emacs commands.
alias e="emacsclient -t -a ''"     # Open Emacs client in terminal mode.
alias eb="emacs -nw -Q -a ''"      # Open Emacs in bare mode (no window system).
alias ec="emacsclient -c -n -a ''" # Open Emacs client in a new frame.
alias emacs="emacsclient -t -a ''" # Open Emacs client in terminal mode.
