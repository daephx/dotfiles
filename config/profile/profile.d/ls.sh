# ls: Conditionally set users ls utility
# shellcheck shell=bash

# Detect which `ls` flavor is in use
if command ls --color > /dev/null; then
  # GNU: ls
  colorflag="--color=auto"
else
  # MacOS: ls
  colorflag="-G"
  export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# Exa color definitions
# https://the.exa.website/docs/colour-themes
export EXA_COLORS="\
gr=34:gw=35:gx=32:sb=32:\
sn=32:tr=34:tw=35:tx=32:\
ue=32:ue=36:un=33:ur=34:\
uu=36:xa=36:uw=35:ux=32:\
da=38;5;240:"

# Assign ls strategy using basic conditions
#
# This sets a default list of potential tools, first has highest priority!
# Loop through list of command until a valid one is found within $PATH
#
# Command can be overwritten by passing an argument directly to this function/script.
# Or, by setting an environment variable with your preferred command: LS_TOOL=ls
# If the command is invalid, then it will keep going down the list, and settle
# on the builtin ls command which is almost guaranteed to be available.
__set_strategy_ls() {
  # Loop default arguments
  set -- eza exa lsd ls
  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array

    # Handle command exceptions
    [ "$cmd" = '' ] && continue # Ignore empty string
    test -x "$(command which "$cmd" 2> /dev/null)" || continue
    case "$cmd" in
      eza | exa) __set_alias_eza ;;
      lsd) __set_alias_lsd ;;
      ls) __set_alias_ls ;;
    esac
    alias ls > /dev/null 2>&1 && break # Break if alias is successfully set
    printf "\e[031mE\e[0m: ls aliases failed to be applied using the command: '%s'\n" "$cmd"
  done
}

# Set command aliases: ls
# shellcheck disable=SC2139
__set_alias_ls() {
  local args=" \
  $colorflag \
  --classify \
  --group-directories-first \
  --human-readable \
  --literal \
  --no-group \
  --show-control-chars \
  --sort=version \
  --time-style=long-iso"
  local cmd="command ls $args"
  alias l.="$cmd -Adl .*"
  alias l="$cmd -l"
  alias la="$cmd -Al"
  alias ll="$cmd -Al"
  alias ls="$cmd"
  alias lt="tree -L 2"
  unalias tree 2>&/dev/null
}

# Set command aliases: lsd
# shellcheck disable=SC2139
__set_alias_lsd() {
  local args=" \
  --group-directories-first"
  local cmd="lsd $args"
  alias l.="$cmd -ald .*"
  alias l="$cmd -l"
  alias la="$cmd -al"
  alias ll="$cmd -al"
  alias ls="$cmd"
  alias lt="$cmd --tree"
  alias tree="$cmd --tree"
}

# Set command aliases: eza
# shellcheck disable=SC2139
__set_alias_eza() {
  local args=" \
  --classify \
  --group-directories-first \
  --icons \
  --time-style=long-iso"
  [ "$cmd" = "eza" ] && args+=" --git"
  local cmd="$cmd $args"
  alias l.="$cmd -adl .*"
  alias l="$cmd -l"
  alias la="$cmd -al"
  alias ll="$cmd -al"
  alias ls="$cmd --icons=never"
  alias lt="$cmd --tree --level=2"
  alias tree="$cmd --tree"
}

# Determine user preferred ls strategy
__set_strategy_ls

# Cleanup functions
unset -f __set_alias_eza
unset -f __set_alias_ls
unset -f __set_alias_lsd
unset -f __set_strategy_ls
