#!/usr/bin/env bash

__root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file=$(basename "${BASH_SOURCE[0]}")
__local="${XDG_LOCAL_HOME:-HOME/.local}"
__msg="echo -e "$LOG_TEMPLATE""

function log() {

  local __LEVELS=("NOTSET" "DEBUG" "INFO" "WARN" "ERROR")

  # disable logging without debug environment varaible
  # TODO: passing debug envvar shows bash stack trace, might need custom envvar for filter/style logs
  # [[ -z "$DEBUG" ]] && return 0

  case "${1}" in
  error) level_label="${RED}ERR${RESET}" ;;   # Error
  warn) level_label="${YELLOW}WRN${RESET}" ;; # Warning
  info) level_label="${WHITE}INF${RESET}" ;;  # Info
  debug) level_label="${CYAN}DBG${RESET}" ;;  # Debug
  *) level_label="" ;;                        # General
  esac

  # supress messages that are below the set log level
  __level="$(get_index ${LOG_LEVEL} ${__LEVELS[@]})"
  __inbound="$(get_index ${1} ${__LEVELS[@]})"
  if [[ "${__inbound}" -lt "${__level}" ]]; then return 0; fi
  shift # remove $1 level label for message list

  # log formatting variables, all options are avalible here:
  # variable names can be expanded from $LOG_TEMPLATE global variable
  timestamp="${RESET}${BBLACK}[${PURPLE}$(date "+%Y-%M-%dT%T.%3N")${RESET}${BBLACK}]${RESET}"
  filename="$(basename ${BASH_SOURCE[2]})"
  function="${FUNCNAME[1]}"
  message="${@}" # human friendly name

  if [[ "${__inbound}" -eq "ERROR" ]]; then eval $__msg 1>&2 && return 1; fi
  eval $__msg 1>&2
}
