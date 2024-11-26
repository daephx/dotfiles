#!/usr/bin/env bash
# Git: Define aliases and functions for git version control.
# shellcheck disable=SC2039

# Do nothing if application is not available.
[ ! -x "$(command -v git)" ] && return

### Aliases ###

# Shorthand commands
alias g="git"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log"
alias gs="git show"
alias gs="git status"

alias difftool="git difftool"

# Mistyped
alias gti="git"

# Custom actions
alias gr="__git_root_dir"

# Fzf enhanced commands
if [ -x "$(command -v fzf)" ]; then
  alias gb="__fzf_git_branches"
  alias gd="__fzf_git_diff"
  alias gl="__fzf_git_log"
  alias gl2="__fzf_git_log2"
  alias gwt="__git_select_worktree"

  alias gitignore="__git_new_gitignore"
fi

# Verify git command and directory before running commands.
__fzf_git_check() {
  git rev-parse HEAD > /dev/null 2>&1 && return
  echo "E: Not a valid git repository: '$PWD'"
  return 1
}

# Open git root directory
__git_root_dir() {
  __fzf_git_check || return
  local root
  root="$(git rev-parse --show-toplevel)"
  cd "$root" && echo "$root"
}

# Open git worktree using FZF
__git_select_worktree() {
  __fzf_git_check || return
  local query dir
  query="${1:-}"
  dir=$(
    git worktree list | fzf \
      --height=100% \
      --preview='git log --color=always --oneline --graph {2}' \
      --query "$query" -1 \
      | awk '{print $1}'
  )
  [ -n "$dir" ] && cd "$dir" || return
}

# Create gitignore file from online template
__git_new_gitignore() {
  local url selected
  url="https://toptal.com/developers/gitignore/api"
  selected=${*:-$(curl -sL "$url/list" | tr , '\n' | fzf --multi --height=50%)}
  args="${selected[*]// /,}"
  prompt="Selected languages: '$args'"
  [ -z "$selected" ] && return
  [ -f ".gitignore" ] && {
    printf "%s\n\nFile .gitignore already exists, this will overwrite the current file! " "$prompt"
    printf "Do you still wish to create new file? [y/N]: "
    read -r answer < /dev/tty
    [ -z "$answer" ] && answer="no"
  }
  [[ $answer =~ ^[Nn]$ ]] && return 1
  curl -sL "$url/$args" > ".gitignore"
}

# Switch git branch using fzf
__fzf_git_branch() {
  __fzf_git_check || return
  choice=$(
    git for-each-ref --format='%(refname:short)' 'refs/heads/*' \
      | fzf \
        --height=40% \
        --reverse \
        --prompt="Switch branch: " \
        --header="Select a branch to switch to"
  ) || return
  git switch "$choice"
}

# List all modified files and display a preview containing the uncommitted diff.
__fzf_git_diff() {
  __fzf_git_check || return
  git diff "$@" --name-only | fzf -m --ansi --preview 'git diff $@ --color=always -- {-1}'
}

# List commit graph by hash and display a preview of the commit message.
__fzf_git_log2() {
  __fzf_git_check || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always \
    | fzf \
      --ansi \
      --height=100% \
      --no-sort \
      --header $'CTRL-O (open in browser) ╱ CTRL-D (diff) ╱ CTRL-S (toggle sort)\n' \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git show --color=always 2> /dev/null' "$@" \
      --bind 'ctrl-d:execute:grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git diff > /dev/tty' \
      --bind 'ctrl-s:toggle-sort' \
    | awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

# Alternative method for exploring git log using fzf
# TODO: Copy to clipboard is not implemented
__fzf_git_log() {
  __fzf_git_check || return
  git_log_view="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | xargs -I % sh -c 'git show --color=always %'"
  git_log_format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)"
  git log --oneline --color=always --date=short --format="$git_log_format" "$@" \
    | fzf -i -e +s \
      --ansi \
      --height=100% \
      --no-multi \
      --reverse \
      --tiebreak=index \
      --header "Enter: View log, y: Copy hash" \
      --preview "${git_log_view}" \
      --bind "enter:execute(${git_log_view} | xargs git diff > /dev/tty)" \
      --bind "y:execute:"
}
