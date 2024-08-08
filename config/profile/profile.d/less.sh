# less: Opposite of more - Linux terminal pager LESS(1)
# shellcheck disable=SC2155
# shellcheck shell=sh

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x "/usr/bin/lesspipe" ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set environment variables for terminal emulators
# such as KDE-Konsole and Gnome-terminal.
export GROFF_NO_SGR=1

# Configure general less command options to improve control over
# text display, navigation, and overall pager behavior.
export LESSCHARSET='utf-8'
export LESSEDIT='nvim -RM ?lm+%lm. %f'
export LESSHISTFILE=-
export LESS=" \
--LONG-PROMPT \
--QUIET \
--RAW-CONTROL-CHARS \
--chop-long-lines \
--ignore-case \
--jump-target=0.5 \
--line-numbers \
--mouse \
--quit-if-one-screen \
--squeeze-blank-lines \
--tilde \
--wheel-lines=3 \
"

# Configure text attributes for the less pager using tput to ensure
# compatibility with various terminal types.

# Begin blinking mode
export LESS_TERMCAP_mb="$(
  tput bold
  tput setaf 6
)"

# Begin bold mode
export LESS_TERMCAP_md="$(
  tput bold
  tput setaf 2
)"

# End mode
export LESS_TERMCAP_me="$(tput sgr0)"

# Begin dim text
export LESS_TERMCAP_mh="$(tput dim)"

# Begin reverse mode
export LESS_TERMCAP_mr="$(tput rev)"

# End standout-mode
export LESS_TERMCAP_se="$(
  tput rmso
  tput sgr0
)"

# Begin standout-mode
export LESS_TERMCAP_so="$(
  tput bold
  tput setaf 3
  tput setab 236
)"

# End underline mode
export LESS_TERMCAP_ue="$(
  tput rmul
  tput sgr0
)"

# Begin underline mode
export LESS_TERMCAP_us="$(
  tput smul
  tput bold
  tput setaf 7
)"

# Begin subscript mode
export LESS_TERMCAP_ZN="$(tput ssubm)"

# Begin superscript mode
export LESS_TERMCAP_ZO="$(tput ssupm)"

# End subscript mode
export LESS_TERMCAP_ZV="$(tput rsubm)"

# End superscript mode
export LESS_TERMCAP_ZW="$(tput rsupm)"
