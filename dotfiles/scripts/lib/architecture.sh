
get_architecture() {

  architecture=""
  case $(uname -m) in
      i386|i686) architecture="386" ;;
      x86_64) architecture="amd64" ;;
      arm) dpkg --print-architecture | grep -q "arm64" && architecture="arm64" || architecture="arm" ;;
      ?*) echo "Could not determine architecture!" 1>&2 && exit 1;;
  esac

  echo $architecture

}

if [ $_ != $0 ]; then
  echo "Script is a subshell"
else
  echo "Script is being sourced"
fi
# Much like pythons: if __name__ == '__main__':
# if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
#     echo "$(get_architecture)"
# fi
