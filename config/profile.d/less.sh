# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Use colors for less, man, etc.
[ -f "$XDG_CONFIG_HOME/LESS_TERMCAP" ] && . "$XDG_CONFIG_HOME/LESS_TERMCAP"

# Set less command properties
export LESS="-QRiFSMn~ \
  --mouse \
  --wheel-lines=3"
export LESSHISTFILE=-
# export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export LESSEDIT='nvim -RM ?lm+%lm. %f'
export LESSCHARSET='utf-8'
