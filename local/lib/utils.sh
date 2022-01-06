# TODO(daephx): Improve example w/ testing
# DESC: Get array index from string value
# ARGS: $1 (required): value to index for <medium>
#       $2 (required): array to index against <(easy medium hard)>
# OUTS: return int <2>
function get_index() {
  item="${1^^}" && shift
  list=("${@}")
  for i in "${!list[@]}"; do
    if [[ "${list[$i]}" = "${item}" ]]; then
      echo "${i}"
    fi
  done
}

function dotenv() {
  local file=$([ -z "$1" ] && echo ".env" || echo ".env.$1")

  if [ -f $file ]; then
    set -a
    source $file
    set +a
  else
    echo "No $file file found" 1>&2
    return 1
  fi
}
