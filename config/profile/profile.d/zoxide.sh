#!/usr/bin/env sh
# zoxide: A smarter cd command. Supports all major shells.
# https://github.com/ajeetdsouza/zoxide

# Do nothing if zoxide is not installed
if ! command -v zoxide > /dev/null; then
  return 0
fi

# Replace default empty cd with zoxide interactive

cd() {
  [ "$#" -eq 0 ] && z "$@" || builtin cd "$@" || return
}

_z_cd() {
  cd "$@" || return "$?"

  if [ "$_ZO_ECHO" = "1" ]; then
    echo "$PWD"
  fi
}

z() {
  if [ "$#" -eq 0 ]; then
    _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
  elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
    if [ -n "$OLDPWD" ]; then
      _z_cd "$OLDPWD"
    else
      echo "zoxide: $OLDPWD is not set"
      return 1
    fi
  else
    _zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
  fi
}

zi() {
  _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
}

zri() {
  _zoxide_result="$(zoxide query -i -- "$@")" && zoxide remove "$_zoxide_result"
}

_zoxide_hook() {
  zoxide add "$(pwd -L)"
}

chpwd_functions=("${chpwd_functions[@]}" "_zoxide_hook")

alias za='zoxide add'
alias zq='zoxide query'
alias zqi='zoxide query -i'
alias zr='zoxide remove'
