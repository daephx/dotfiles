#!/usr/bin/env bash

function include() {
  # DESC: Import library scripts with less clutter
  # ARGS: $1 File path starting from library path
  # OUTS: None

  __root="$(dirname "${BASH_SOURCE[0]}")"
  __local="${XDG_LOCAL_HOME:-HOME/.local}"

  local file="${__root}/$1"
  local error="Cannot find \e[1m$1\e[0m library at: \e[2m$file\e[0m"
  if [ ! -f "$file" ]; then log error $error; fi
  source "$file"
  log debug "Sourcing file: '$file'"
}
