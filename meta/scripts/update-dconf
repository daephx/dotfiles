#!/usr/bin/env bash

function usage() {
  echo -e "\n${__file}: dconf quick actions!\n"
  echo -e "  -d | --dump\t Dump current dconf settings to ini file"
  echo -e "  -r | --reset\t Reset current dconf settings (Please create a dump first)"
  echo -e "  -u | --update\t Update dconf settings from ini file"
  echo -e "\n  filepath\t Target ini file for dconf settings"
  echo && exit 1
}

function main() {
  set -e # stop execution if return not 0

  __root="$(dirname "${BASH_SOURCE}")"
  __file=$(basename "${BASH_SOURCE[0]}")

  test -d dotfiles/dconf || mkdir dotfiles/dconf
  if (($# < 2)); then usage; fi

  parse_arguments $@
  conf_file="$POSITIONAL"

  # Reset stratagy
  if [[ $STRAT == "reset" ]]; then
    echo -e "This operation cannot be undone, please create a backup '${__file} -d output.ini'"
    read -p "are you sure? " -n 1 -r
    echo # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      dconf reset -f /
    fi
    read -p
    echo "Factory reset current dconf settings" 1>&2
  fi

  # Dump stratagy
  if [[ $STRAT == "dump" ]]; then
    test -f $conf_file && echo -e "ERR: config file already exists: '$conf_file'" 1>&2 && exit 1
    echo "Dumping config to '$conf_file'" 1>&2
    dconf dump / >$conf_file
  fi

  # Update stratagy
  if [[ $STRAT == "update" ]]; then
    test -f $conf_file || echo -e "ERR: config file doesn't exist: '$conf_file'" 1>&2 && exit 1
    echo "Updating config from '$conf_file'" 1>&2
    dconf load / <$conf_file
  fi
}

function parse_arguments() {
  POSITIONAL=()
  while (($# > 0)); do
    case "${1}" in
    -u | --update)
      STRAT="update"
      shift
      ;;
    -d | --dump)
      STRAT="dump"
      shift
      ;;
    -r | --reset)
      STRAT="reset"
      shift
      ;;
    -*?) # unknown flag/switch
      echo -e "ERR: Unknown paramater '${1}'" 1>&2
      usage
      ;;
    *) # remaining arguments
      POSITIONAL+=("${1}")
      shift
      ;;
    esac
  done
  set -- "${POSITIONAL[@]}" # restore positional params
}

# Much like pythons: if __name__ == '__main__':
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
  main "$@"
fi
