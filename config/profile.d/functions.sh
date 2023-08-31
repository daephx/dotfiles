# ~/.functions: Common functions for POSIX shells
# shellcheck shell=sh

# Extract archive formats
# Usage: extract <path/to/file>
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.xz) tar xf "$1" ;;
      *.tar.zst) unzstd "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.rar) unrar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" ;;
      *.Z) uncompress "$1" ;;
      *.7z) 7z x "$1" ;;
      *.deb) ar x "$1" ;;
      *) printf "\e[31mE\e[0m: Unsupported filetype: '%s'\n" "$1" ;;
    esac
  else
    printf "\e[31mE\e[0m: Invalid file: '%s'\n" "$1"
  fi
}

# Get absolute path
# Usage: abspath <path/to/item>
abspath() {
  cd "$(dirname "$1")" > /dev/null || return
  printf "%s/%s\n" "$(pwd)" "$(basename "$1")"
  cd - || return
}

# Create path on touch
# Usage: touchd <path/to/file>
touchd() {
  mkdir -p "${1%/*}" && touch "$1"
}

# Create and change directory
# Usage: mk </dir/path>
mk() {
  mkdir -p -- "$1" && cd -P -- "$1" || return
}

# FZF Changing Directories
fcd() {
  cd "$(find ~ -maxdepth 5 -not -path '*/\.git/*' -type d \
    | fzf --height 40% --reverse)" || return
}

fbr() {
  choice=$(
    git for-each-ref --format='%(refname:short)' 'refs/heads/*' | fzf \
      --prompt="Switch branch: " \
      --header="Select a branch to switch to" \
      --height 40% --reverse
  )
  git switch "$choice"
}

