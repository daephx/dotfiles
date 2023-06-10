# ls: Conditionally set users ls utility

# Detect which `ls` flavor is in use
if command ls --color > /dev/null; then # GNU `ls`
  colorflag="--color=auto"
else # MacOS `ls`
  colorflag="-G"
  export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# Override and extend ls command: gnu_ls
__set_alias_ls() {
  local default_arguments=" \
  $colorflag \
  --classify \
  --group-directories-first \
  --literal \
  --show-control-chars \
  --sort=version"
  # shellcheck disable=SC2139
  alias ls="ls $default_arguments"
  alias l="ls -Cl"
  alias ll="ls -ClA"
  alias la="ls -A"
  alias ll="ls -alF"
  alias lt="tree"
}

# Override and extend ls command: lsd
__set_alias_lsd() {
  local default_arguments=" \
  --group-directories-first"
  # shellcheck disable=SC2139
  alias lsd="lsd $default_arguments"
  alias ls="lsd"
  alias l="lsd -l"
  alias ll="lsd -al"
  alias la="lsd -al"
  alias lt="lsd --tree"
  alias tree="lsd --tree"
}

# Override and extend ls command: exa
__set_alias_exa() {
  export EXA_COLORS="da=34:gr=34:gw=35:gx=32:sb=32:sn=32:tr=34:tw=35:tx=32:ue=32:ue=36:un=33:ur=34:uu=36:xa=36:uw=35:ux=32:"
  local default_arguments=" \
  --icons \
  --classify \
  --time-style=long-iso \
  --group-directories-first"
  # shellcheck disable=SC2139
  alias exa="exa $default_arguments"
  alias ls="exa --no-icons"
  alias l="exa -l"
  alias la="exa -al"
  alias lg="exa --git"
  alias ll="exa -al"
  alias lt="exa --tree --level=2"
  alias tree="exa --tree"
}

ls_cmd() {
  # Define list utils if no argument supplied
  [ $# -eq 0 ] && set -- exa lsd ls
  # Loop available arguments
  while [ "$#" -gt 0 ]; do
    cmd="$1" # Set value to temp variable
    shift 1  # Shift to next variable in array
    # Skip apps that are not in PATH
    command -v "$cmd" > /dev/null || continue
    case "$cmd" in
      exa) __set_alias_exa ;;
      lsd) __set_alias_lsd ;;
      ls) __set_alias_ls ;;
      *?) printf "E: Unknown ls command selected: '%s'\n" "$cmd" ;;
    esac
    # Break if `ls` alias is set
    alias ls > /dev/null 2>&1 && break
  done
}

# Execute ls util function
ls_cmd
