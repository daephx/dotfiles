# shellcheck shell=sh
if ! command -v zoxide >/dev/null; then
  return 0
fi

# Replace default empty cd with zoxide interactive

cd() {
  [ "$#" -eq 0 ] && z "$@" || builtin cd "$@" || return
}

z() {
  if [ "$#" -eq 0 ]; then
    _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
  elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
    if [ -n "$OLDPWD" ]; then
      _z_cd "$OLDPWD"
    else
      echo "zoxide: \$OLDPWD is not set"
      return 1
    fi
  else
    _zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
  fi
}
