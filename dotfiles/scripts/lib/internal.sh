#!/usr/bin/env bash
# Bash template. MIT License, ralish/bash-script-template

# Set magic variables
__root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="$(basename "${__root}")"
__local="$(cd "$(dirname "${__root}")" && pwd)"
__lib="${__root}" # alias __root

function __initalize() {

  # DESC: Initalize environment bin scripts
  # NOTE: This function is only called when this script
  #       is sourced by another script.

  # Enable xtrace if the DEBUG environment variable is set
  if [[ ${DEBUG-} =~ ^1|yes|true$ ]]; then
    set -o xtrace # Trace the execution of the script (debug)
  fi
  # Only enable these shell behaviours if we're not being sourced
  # Approach via: https://stackoverflow.com/a/28776166/8787985
  if ! (return 0 2>/dev/null); then
    # A better class of script...
    set -o errexit  # Exit on most errors (see the manual)
    set -o nounset  # Disallow expansion of unset variables
    set -o pipefail # Use last non-zero exit code in a pipeline
  fi
  # Enable errtrace or the error trap handler will not work as expected
  set -o errtrace # Ensure the error trap handler is inherited

  __bin="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
  __exe="${__root}/$(basename "${BASH_SOURCE[1]}")"
  __base="$(basename ${__exe} .sh)"

  # initalize general config
  LOG_LEVEL="debug"
  LOG_TEMPLATE="\$timestamp \$level_label: \$filename: \$function: \$message"

  include "colors.sh"  # ! (CORE) ansii color vars
  include "utils.sh"   # ! (CORE) core utilities
  include "logging.sh" # ! (CORE) logging framework

  # General dependiencies
  include "include.sh" # better source/include function
  include "hello.sh"

}

# DESC: Test that the initalizer is working
# ARGS: None
# OUTS: None
function __test() {

  # Testing log output
  log "--- Environemnt: internal ---"
  log debug "Initalizing ${__root}:"

  # display library variables
  log debug "Standard Variables: __root \t= ${__root}"
  log debug "Standard Variables: __local \t= ${__local}"
  log debug "Standard Variables: __bin \t= ${__bin}"
  log debug "Standard Variables: __exe \t= ${__exe}"
  log debug "Standard Variables: __base \t= ${__base}"

  # some more random output
  message="Pat ordered a ghost pepper pie."
  log debug "${message}"
  log info "${message}"
  log warn "${message}"
  log error "${message}" # ? should if `set -e` kill script

}

# Define Minimal implimentation:
# these functions will likely be overwritten by environment scripts
# in order to perserve compatability we define basic implimentations,
# a replicas to stand in until the bigger function can take its palce.
log() { [ -z "$DEBUG" ] && l=$1 && shift && echo -e "${l^^}: ${@}" 1>&2; }
include() { f="${__lib}/$1" && [ -f $f ] && source $f; }

# Much like pythons: if __name__ != '__main__':
if [ ! "${BASH_SOURCE[0]}" == "${0}" ]; then
  # initalize environment
  __initalize "$@"
  __test "$@"
fi
