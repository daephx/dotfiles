# ~/.aliases: user aliases for interactive POSIX shells
# shellcheck disable=1001

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

alias tmp="cd /tmp"  # System Temp
alias temp="cd /tmp" # System Temp

# Common mistakes
alias brwe="brew"
alias where="which" # Damn it Microsoft!
alias emasc="emacs"
alias emcas="emacs"

# Exit mistakes
alias \:q='exit'
alias \:qa='exit'
alias \:xa="exit"
alias eexit="exit"
alias eit="exit"
alias exot="exit"
alias Q='exit'
alias q='exit'
alias qa='exit'
alias x='exit'
alias Xa="exit"
alias xa="exit"
alias xit="exit"

# Editors
alias e="eval \$VISUAL"
alias edit="eval \$VISUAL"

# TODO: vi should be vim/nvim: never emacs
# Instead of setting to visual, scrape for nvim, vim, vi in that order
alias vi="eval \$VISUAL"

# Clear terminal output
alias cls="clear"

# list mounted drives
alias mnt="mount | grep -E ^/dev | column -t | less"

# Count number of files in current directory
alias count='find . -type f | wc -l'

# Output the current shell PID
alias shell="ps -p \$$"

# shorten xdg_open
alias open='xdg-open &>/dev/null'

# Hide exit output
alias exit="exit &>/dev/null"

# Enable sudo to expand aliases
alias sudo="sudo"

# Reload current shell session
reload() {
  clear && exec $(sh -c 'ps -p $$ -o ppid=' |
    xargs -I'{}' readlink -f '/proc/{}/exe')
}

# Print each PATH entry on a separate line
alias path='echo -e "${PATH//:/\\n}" | less'

# Shorthand to display command history
alias hist="history"

# Recursively delete empty directories
alias empty="find . -empty -type d -print -delete"

# Prefer less as pager
alias more="less"

# Go to sleep
if command -v systemctl > /dev/null; then
  alias zzz="systemctl suspend"
fi

### Utilities ###

# Override and extend ls command: ls
_alias_override_ls() {
  # Detect which `ls` flavor is in use
  if command ls --color > /dev/null; then # GNU `ls`
    colorflag="--color=auto"
    eval 'dircolors $XDG_CONFIG_HOME/LS_COLORS' > /dev/null
  else # MacOS `ls`
    colorflag="-G"
    export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
  fi
  local default_arguments=" \
  $colorflag -vFN \
  --show-control-chars \
  --group-directories-first"
  # shellcheck disable=SC2139
  alias ls="command ls $default_arguments"
  alias l="ls -CFl"
  alias la="ls -A"
  alias ll="ls -alF"
}

# Override and extend ls command: lsd
_alias_override_lsd() {
  local default_arguments="
  --group-directories-first"
  # shellcheck disable=SC2139
  alias lsd="lsd $default_arguments"
  alias ls="lsd"
  alias l="lsd -l"
  alias ll="lsd -al"
  alias la="lsd -al"
  alias lt="lsd --tree"
  alias tree="lsd --tree"
}

# Override and extend ls command: exa
_alias_override_exa() {
  local default_arguments=" \
  --icons \
  --time-style=long-iso \
  --group-directories-first"
  # shellcheck disable=SC2139
  alias exa="exa $default_arguments"
  alias ls="exa --no-icons"
  alias l="exa -l"
  alias la="exa -al"
  alias lg="exa --git"
  alias ll="exa -al"
  alias lt="exa --tree --level=2"
  alias tree="exa --tree"
}

# FIX: Negative side effect where $@ is exposed to the shell environment
# Determine ls utility, Break loop on first found
# Priority determined left-right
set -- exa lsd ls
for _ls in "$@"; do
  if command -v "$_ls" > /dev/null; then
    break
  fi
done

# Apply utility specific overrides
case "$_ls" in
  ls) _alias_override_ls ;;
  lsd) _alias_override_lsd ;;
  exa) _alias_override_exa ;;
  ?*) echo "E: Unknown options for ls alias '$_ls'" ;;
esac

# Always enable colored `grep` output
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# File access
alias zconf="vi \$XDG_CONFIG_HOME/zsh/zshrc"
alias bconf="vi \$XDG_CONFIG_HOME/bash/bashrc"
alias cp="cp -riv"
alias mv="mv -iv"
alias mkdir="mkdir -vp"

# human-readable sizes
alias df="df -h"

# File size
alias fs="stat -f \"%z bytes\""

# un tar archive
alias untar='tar xvf'

# Recursively delete `.DS_Store` files
alias ds_cleanup="find . -type f -name '*.DS_Store' -ls -delete"

# Return the current public IP address
alias myip="curl http://ipecho.net/plain; echo"

# forgetful ifconfig
if ! command -v ifconfig > /dev/null; then
  alias ifconfig='ip -c a'
fi

# Git version control
if command -v git > /dev/null; then
  alias difftool="git difftool"
  alias g="git"
  alias gb="git branch"
  alias gc="git commit"
  alias gs="git show"
  alias gs="git status"
  alias gti="git"
fi

gr() {
  local root
  root="$(git rev-parse --show-toplevel)"
  cd "$root" && echo "$root"
}

gwt() {
  local wtdir query
  query="${1:- }"
  wtdir=$(
    git worktree list \
      | fzf --preview-window up,5,border-horizontal \
        --preview='git log --color=always --oneline --graph -n10 {2}' \
        --query "$query" -1 \
      | awk '{print $1}'
  )
  [ -n "$wtdir" ] && cd "$wtdir" || return
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd) fzf "$@" --preview 'tree -C {} | head -200' ;;
    *) fzf "$@" ;;
  esac
}

# Create gitignore file from online template
_git_new_ignore() {
  local url
  url="https://www.toptal.com/developers/gitignore/api"
  curl -sL "$url/$*" >> .gitignore
}
alias ignore="_git_new_ignore"

# Docker container list
if command -v docker > /dev/null; then
  alias dps="docker ps | less -S"
  alias ctop='docker run --rm -ti --name=ctop -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorlab/ctop:latest'
  alias dcup="docker compose pull && docker compose ps --format '{{.Names}}'"
fi

# Bat | Cat w/ wings
# HACK: alias bat command if batcat is installed
# execute the following command to ignore this fix:
# sudo ln -s /usr/bin/batcat /usr/local/bin/bat
if command -v batcat > /dev/null; then
  _batlog() {
    tail -f "$1" | bat -l=log --theme base16 --pager=never --color=always --decorations=never
  }
  alias logf="_batlog"
  _bathelp() {
    "$@" --help 2>&1 | bat --plain --language=help
  }
  alias help='_bathelp'
  if ! command -v bat > /dev/null; then
    alias bat="batcat"
  fi
fi

# If fd-find is installed
if command -v fdfind > /dev/null; then
  if ! alias fd > /dev/null 2>&1; then
    alias fd="fdfind"
  fi
fi

# Shorthand for python
alias py="/usr/bin/env python"
if command -v ipython > /dev/null; then
  alias ipy="ipython"
fi

# Ensure NCDU utility starts with colors
if command -v ncdu > /dev/null; then
  alias ncdu='ncdu --color dark'
  alias du='ncdu --color dark'
fi

# Python based syntax highlight like cat
if command -v pygmentize > /dev/null; then
  _pygmentize() {
    pygmentize -l "$1" "$2" | less -R
  }
  alias pygmentize="_pygmentize"
fi

# Xclip commands
if command -v xclip > /dev/null; then
  # copy working directory | Requires xclip
  alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard && echo "=> Working Directory copied to pasteboard."'

  # Pipe my public key to my clipboard. | Requires xclip
  alias public_key="less ~/.ssh/id_ed25519.pub | xclip -selection clipboard && echo '=> Public key copied to pasteboard.'"

  # Pipe my private key to my clipboard. | Requires xclip
  alias private_key="less ~/.ssh//id_rsa | xclip -selection clipboard && echo '=> Private key copied to pasteboard.'"
fi

# dstask: shorthand to 'task'
if command -v dstask > /dev/null; then
  alias task="dstask"
fi

# TODO: Include fzf command references from wiki, specifically docker.
# https://github.com/junegunn/fzf/wiki/examples#man-pages

fman() {
  man -k . \
    | fzf -q "$1" \
      --height=100% \
      --prompt='man> ' \
      --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man | col -bx | bat -l man -p --color always' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}
# Get the colors in the opened man page itself
# export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"

if command -v fzf > /dev/null; then
  __fzf_widget_man() {
    if [ -n "$1" ]; then command man "$1" && return 0; fi
    # res=$(command man -k . | fzf --preview="command man $(echo "{}" | cut -d ' ' -f1)")
    res=$(command man -k . | fzf --preview="cmd=\$(echo '{}' | cut -d ' ' -f1); command man \$cmd")
    if [ -n "$res" ]; then
      clear # Prevent prompt display error
      command man "$(echo "$res" | cut -d ' ' -f1)"
    fi
  }

  alias \?="__fzf_widget_man"
  # alias man="__fzf_widget_man"
fi

# cd and list directory
cx() { cd "$@" && ls -l; }

# Ripgrep paging
# alias rg='rg -p -i'
# NOTE: Json flag doesn't work with other flags like files-with-matches
# if command -v delta >/dev/null; then
#   rg() { command rg --json "$@" | delta; }
# fi

# Send files to Trash from command line
alias trash="mv --force -t ~/.local/share/Trash"

# Copy alternative with progress bar
alias cpv="rsync -ah --info=progress2"

# Python create virtual environment
alias ve="python -m venv ./.venv"
alias va="source ./venv/bin/activate"
