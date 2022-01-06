#!/usr/bin/env bash

function _spinner() {

  # Basic usage:
  # ! Do not call _spinner directly. instead use,
  # $ start_spinner "$MESSAGE"; sleep 3 ; stop_spinner $?

  # start/stop $1
  # on start:  $2 display message
  # on stop :  $2 process exit status
  # PID        $3 spinner function pid (supplied from stop_spinner)

  local on_success="DONE"
  local on_fail="FAIL"
  local white="\e[1;37m"
  local green="\e[1;32m"
  local red="\e[1;31m"
  local nc="\e[0m"

  case $1 in
  start)
    # calculate the column where spinner and status msg will be displayed
    let column=$(tput cols)-${#2}-8
    # display message and position the cursor in $column column
    echo -ne ${2}
    printf "%${column}s"

    # start spinner
    i=1
    sp='\|/-'
    delay=${SPINNER_DELAY:-0.15}

    while :; do
      printf "\b${sp:i++%${#sp}:1}"
      sleep $delay
    done
    ;;
  stop)
    if [[ -z ${3} ]]; then
      echo "spinner is not running.."
      exit 1
    fi

    kill $3 >/dev/null 2>&1

    # inform the user uppon success or failure
    echo -en "\b["
    if [[ $2 -eq 0 ]]; then
      echo -en "${green}${on_success}${nc}"
    else
      echo -en "${red}${on_fail}${nc}"
    fi
    echo -e "]"
    ;;
  *)
    echo "invalid argument, try {start/stop}"
    exit 1
    ;;
  esac
}

function start_spinner {
  # $1 : msg to display
  _spinner "start" "${1}" &
  # set global spinner pid
  _sp_pid=$!
  disown
}

function stop_spinner {
  # $1 : command exit status
  _spinner "stop" $1 $_sp_pid
  unset _sp_pid
}

function _test() {

  # Example, this will only run if the script is executed
  # it will NOT run when sourced.

  for ((i = 0; i <= 10; i++)); do
    start_spinner "INSTALLING: Pretend application v2.4.1-r21w12 <Commodo cupidatat non nisi do.>"
    sleep 2         # ! the spinner MUST sleep
    stop_spinner $? # ! always turn off spinner
  done
  echo -e "\rInstallation Process Complete."
}

if [[ ! "${BASH_SOURCE[0]}" != "${0}" ]]; then
  _test "$@"
fi
