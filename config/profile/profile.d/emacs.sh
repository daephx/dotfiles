# Emacs
export EMACSDIR="$XDG_CONFIG_HOME/emacs"
export DOOMDIR="$XDG_CONFIG_HOME/doom"
if [ -d "$EMACSDIR" ]; then
  export PATH="$PATH:${EMACSDIR}/bin"
fi
