#!/usr/bin/env sh

__root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__local="${XDG_LOCAL_HOME:-HOME/.local}"
__lib="${__root}" # alias __root

function include() {
  # DESC: Import library scripts with less clutter
  # ARGS: $1 File path starting from library path
  # OUTS: None
  local file="${__lib:-$XDG_LOCAL_DIR/lib}/$1"
  local error="Cannot find \e[1m$1\e[0m library at: \e[2m$file\e[0m"
  if [ ! -f "$file" ]; then log error $error; fi
  source "$file"
  log debug "Sourcing file: '$file'"
}
