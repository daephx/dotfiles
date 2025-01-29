#!/usr/bin/env sh
# ls alias setup: Configure common 'ls' aliases (e.g., ls, ll, lt)
# to use preferred 'ls' command providers with customized output options.
#
# This script sets up aliases like `ls`, `ll`, and `lt` to use tools such as eza,
# exa, lsd, or the built-in `ls`, depending on availability. It embeds specific
# flags and arguments for customizing output (e.g., sorting, file size, timestamp).

# Exa color definitions
# https://the.exa.website/docs/colour-themes
export EXA_COLORS="\
gr=34:gw=35:gx=32:sb=32:\
sn=32:tr=34:tw=35:tx=32:\
ue=32:ue=36:un=33:ur=34:\
uu=36:xa=36:uw=35:ux=32:\
da=38;5;240:"

# Check available 'ls' commands and set up aliases for the first one found.
__set_strategy_ls() {
  # Default list of ls commands, in order of priority
  set -- eza exa lsd ls

  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array

    # Handle command exceptions
    [ "$cmd" = '' ] && continue # Ignore empty string
    test -x "$(which "$cmd" 2> /dev/null)" || continue
    case "$cmd" in
      eza | exa) __set_alias_eza ;;
      lsd) __set_alias_lsd ;;
      ls) __set_alias_ls ;;
    esac
    alias ls > /dev/null 2>&1 && break # Break if alias is successfully set
    printf "\e[031mE\e[0m: command '%s' exists but failed to apply aliases.\n" "$cmd"
  done
}

# Setup command aliases: ls
# shellcheck disable=SC2139
__set_alias_ls() {
  # Detect which `ls` flavor is in use
  if command ls --color > /dev/null; then
    # GNU: ls
    colorflag="--color=auto"
  else
    # MacOS: ls
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
  fi

  args=" \
  $colorflag \
  --classify \
  --group-directories-first \
  --human-readable \
  --literal \
  --no-group \
  --show-control-chars \
  --sort=version \
  --time-style=long-iso"

  alias l.="$cmd $args -Adl .*"
  alias l="$cmd $args -l"
  alias la="$cmd $args -Al"
  alias ll="$cmd $args -Al"
  alias ls="$cmd $args"
  alias lt="\tree -L 2"
  alias tree="\tree -L 2"
}

# Setup command aliases: lsd
# shellcheck disable=SC2139
__set_alias_lsd() {
  args=" \
  --group-directories-first"

  alias l.="$cmd $args -ald .*"
  alias l="$cmd $args -l"
  alias la="$cmd $args -al"
  alias ll="$cmd $args -al"
  alias ls="$cmd $args"
  alias lt="$cmd $args --tree"
  alias tree="$cmd $args --tree"
}

# Setup command aliases: eza
# shellcheck disable=SC2139
__set_alias_eza() {
  args=" \
  --classify \
  --group-directories-first \
  --icons \
  --time-style=long-iso"

  # Append --git if supported
  $cmd --git >/dev/null 2>&1 && args="$args --git"

  alias l.="$cmd $args -adl .*"
  alias l="$cmd $args -l"
  alias la="$cmd $args -al"
  alias ll="$cmd $args -al"
  alias ls="$cmd $args --icons=never"
  alias lt="$cmd $args --tree --level=2"
  alias tree="$cmd $args --tree"
}

# Call the main function to configure aliases
__set_strategy_ls

# Remove helper functions to clean up environment
unset -f __set_alias_eza
unset -f __set_alias_ls
unset -f __set_alias_lsd
unset -f __set_strategy_ls
