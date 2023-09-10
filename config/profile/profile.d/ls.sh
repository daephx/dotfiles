# ls: Conditionally set users ls utility

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
da=38;5;240:gr=34:gw=35:\
gx=32:sb=32:sn=32:tr=34:\
tw=35:tx=32:ue=32:ue=36:\
un=33:ur=34:uu=36:xa=36:\
uw=35:ux=32:"

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
  set -- "$1" "$LS_TOOL" eza exa lsd ls
  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array
    case "$cmd" in
      eza | exa) __set_alias_exa ;;
      lsd) __set_alias_lsd ;;
      ls) __set_alias_ls ;;
      *?) printf "\e[031mE\e[0m: __set_strategy_ls: Invalid: command is not a valid ls provider: '%s'\n" "$cmd" ;;
    esac
    # Validate command and break if alias is defined: `ls`
    [ -z "$cmd" ] && continue
    test -x "$(command which "$cmd")" && break
    printf "\e[031mE\e[0m: __set_strategy_ls: Invalid: command could not be found in PATH: '%s'\n" "$cmd"
  done
}

# Set command aliases: ls
# shellcheck disable=SC2139
__set_alias_ls() {
  local args=" \
  $colorflag \
  --classify \
  --group-directories-first \
  --literal \
  --show-control-chars \
  --sort=version"
  local cmd="command ls $args"
  alias ls="$cmd"
  alias l="$cmd -Cl"
  alias ll="$cmd -ClA"
  alias la="$cmd -A"
  alias ll="$cmd -alF"
  alias lt="tree"
  unalias tree 2>&/dev/null
}

# Set command aliases: lsd
# shellcheck disable=SC2139
__set_alias_lsd() {
  local args=" \
  --group-directories-first"
  local cmd="lsd $args"
  alias ls="$cmd"
  alias l="$cmd -l"
  alias ll="$cmd -al"
  alias la="$cmd -al"
  alias lt="$cmd --tree"
  alias tree="$cmd --tree"
}

# Set command aliases: exa | eza
# shellcheck disable=SC2139
__set_alias_exa() {
  local args=" \
  --icons \
  --classify \
  --time-style=long-iso \
  --group-directories-first"
  [ "$cmd" = "eza" ] && args+=" --git"
  local cmd="$cmd $args"
  alias ls="$cmd --no-icons"
  alias l="$cmd -l"
  alias la="$cmd -al"
  alias ll="$cmd -al"
  alias lt="$cmd --tree --level=2"
  alias tree="$cmd --tree"
}

# Determine user preferred ls strategy
__set_strategy_ls "$@"
