#!/usr/bin/env bash
# aliases: user aliases for interactive POSIX shells
# shellcheck disable=SC1001

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### System ###

# Easier navigation
alias -- -="cd -"            # Previous directory
alias .....="cd ../../../.." # 4 Parents
alias ....="cd ../../.."     # 3 Parents
alias ...="cd ../.."         # 2 Parents
alias ..="cd .."             # 1 Parent
alias ~="cd ~"               # HOME `cd`|`~`

alias temp="cd /tmp" # System Temp
alias tmp="cd /tmp"  # System Temp

# Add options to common file operations
alias cp="cp -riv"
alias mv="mv -iv"
alias rm='rm -iv'

# Clear terminal output
alias cls="clear"

# Hide exit output
alias exit="exit &>/dev/null"

# Quick exit
alias q='exit'

# Make directory: verbose, parent
alias mkdir="mkdir -vp"

# Enable sudo to expand aliases
alias sudo="sudo"

# shorten xdg_open
alias open='xdg-open &>/dev/null'

# Shorthand to display command history
alias hist="history"

# Output the current shell PID
alias shell="ps -p \$$"

# Print each PATH entry on a separate line
alias path='echo -e "${PATH//:/\\n}" | less'

# list mounted drives
alias mnt="mount | grep -E ^/dev | column -t | less"

# Count number of files in current directory
alias count='find . -type f | wc -l'

# Recursively delete empty directories
alias empty="find . -empty -type d -print -delete"

# Common mistakes
alias brwe="brew"
alias emasc="emacs"
alias emcas="emacs"
alias where="which"

### Utilities ###

# Send files to Trash from command line
# alias trash="mv --force -t ~/.local/share/Trash"
# alias rm='trash -v'

# Copy alternative with progress bar
alias cpv="rsync -ah --info=progress2"

# Always enable colored `grep` output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# File size
alias fs="stat -f \"%z bytes\""

# human-readable sizes
alias df="df -h"

# extract tar archive
alias untar='tar xvf'

# Recursively delete `.DS_Store` files
alias ds_cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Return the current public IP address
alias myip="curl http://ipecho.net/plain; echo"

# Get week number
alias week='date +%V'

# Prefer less as pager
if ! command -v more > /dev/null; then
  alias more="less"
fi

# forgetful ifconfig
if ! command -v ifconfig > /dev/null; then
  alias ifconfig='ip -c a'
fi

# Copy commands: xclip
if command -v xclip > /dev/null; then
  # copy working directory
  alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard && echo "=> Working Directory copied to clipboard."'

  # Pipe my public key to my clipboard.
  alias public_key="less ~/.ssh/id_ed25519.pub | xclip -selection clipboard && echo '=> Public key copied to clipboard.'"

  # Pipe my private key to my clipboard.
  alias private_key="less ~/.ssh//id_rsa | xclip -selection clipboard && echo '=> Private key copied to clipboard.'"
fi

# bat: Replacement command for cat
if command -v bat > /dev/null; then
  _batlog() {
    tail -f "$1" | bat -l=log --pager=never --color=always --decorations=never
  }
  alias cat="bat"
  alias help='_bathelp'
  alias logf="_batlog"
fi

# Ripgrep paging
# alias rg='rg -p -i'
# NOTE: Json flag doesn't work with other flags like files-with-matches
if command -v delta > /dev/null; then
  rg() { command rg --json "$@" | delta; }
fi

# Ensure NCDU utility starts with colors
if command -v ncdu > /dev/null; then
  alias ncdu='ncdu --color dark'
  alias du='ncdu --color dark'
fi

# dstask: shorthand to 'task'
if command -v dstask > /dev/null; then
  alias task="dstask"
fi

# Reload current shell session
reload() {
  clear && exec $(sh -c 'ps -p $$ -o ppid=' \
    | xargs -I'{}' readlink -f '/proc/{}/exe')
}

# Create and change directory
# Usage: mk </dir/path>
mk() { mkdir -p -- "$1" && cd -P -- "$1" || return; }

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
      *.rar) rar x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.tar) tar xf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.zip) unzip "$1" -d "${1%.zip}" ;;
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

# Rename current working directory
rename() {
  cd . || return
  new_dir=${PWD%/*}/$1
  mv -- "$PWD" "$new_dir" \
    && cd -- "$new_dir" || exit
}

# Create path on touch
# Usage: touchd <path/to/file>
touchd() {
  mkdir -p "${1%/*}" && touch "$1"
}
