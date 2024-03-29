# Less: Opposite of more - Linux terminal pager
# shellcheck disable=SC2155

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set less command options
export LESSCHARSET='utf-8'
export LESSEDIT='nvim -RM ?lm+%lm. %f'
export LESSHISTFILE=-

export LESS="-QRiFSMn~ \
  --mouse \
  --wheel-lines=3"

export GROFF_NO_SGR=1 # For Konsole and Gnome-terminal

export LESS_TERMCAP_mb="$(
  tput bold
  tput setaf 6
)" # begin blinking
export LESS_TERMCAP_md="$(
  tput bold
  tput setaf 2
)"                                    # begin bold
export LESS_TERMCAP_me="$(tput sgr0)" # mode end
export LESS_TERMCAP_mh="$(tput dim)"
export LESS_TERMCAP_mr="$(tput rev)"
export LESS_TERMCAP_se="$(
  tput rmso
  tput sgr0
)" # standout-mode end
export LESS_TERMCAP_so="$(
  tput bold
  tput setaf 3
  tput setab 0
)" # begin standout-mode
export LESS_TERMCAP_ue="$(
  tput rmul
  tput sgr0
)" # underline end
export LESS_TERMCAP_us="$(
  tput smul
  tput bold
  tput setaf 7
)" # underline start
export LESS_TERMCAP_ZN="$(tput ssubm)"
export LESS_TERMCAP_ZO="$(tput ssupm)"
export LESS_TERMCAP_ZV="$(tput rsubm)"
export LESS_TERMCAP_ZW="$(tput rsupm)"
