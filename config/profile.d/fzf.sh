# FZF Configuration
if [[ ! -d "$HOME/.fzf" ]]; then
  return
fi

if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME/.fzf/bin"
fi

[[ -n $BASH_VERSION ]] && {
  [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null
  source "$HOME/.fzf/shell/key-bindings.bash"
}

[[ -n $ZSH_VERSION ]] && {
  [[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null
  source "$HOME/.fzf/shell/key-bindings.zsh"
}

# ---

# Movement Bindings
FZF_MOVEMENT=" \
  --bind='alt-a:toggle-all' \
  --bind='alt-d:page-down+refresh-preview' \
  --bind='alt-g:ignore' \
  --bind='alt-h:backward-char+refresh-preview' \
  --bind='alt-l:forward-char+refresh-preview' \
  --bind='alt-p:toggle-preview' \
  --bind='alt-s:toggle-sort' \
  --bind='alt-u:page-up+refresh-preview' \
  --bind='alt-y:yank' \
  --bind='ctrl-d:half-page-down+refresh-preview' \
  --bind='ctrl-g:top' \
  --bind='ctrl-l:clear-screen' \
  --bind='ctrl-s:preview-page-up' \
  --bind='ctrl-x:preview-page-down' \
  --bind='ctrl-u:half-page-up+refresh-preview' \
  --bind='ctrl-y:kill-line' \
  --bind='esc:unix-line-discard' \
  --bind='home:top'"

# --bind='ctrl-pgdn:preview-down'
# --bind='ctrl-pgup:preview-up'

# Colorscheme
FZF_COLORS=" \
  --color=dark \
  --color=bg+:-1 \
  --color=bg:-1 \
  --color=gutter:-1 \
  --color=border:8 \
  --color=fg+:15 \
  --color=fg:8 \
  --color=header:3 \
  --color=hl+:3 \
  --color=hl:6 \
  --color=info:5 \
  --color=marker:6 \
  --color=pointer:3 \
  --color=preview-fg:7 \
  --color=prompt:4 \
  --color=spinner:3"

# Export variables
export FZF_DEFAULT_COMMAND="rg -uu --files -H"
export FZF_ALT_COMMAND="fd -uu -t f"
export FZF_DEFAULT_OPTS=" \
  $FZF_COLORS \
  $FZF_MOVEMENT \
  --info=inline \
  --preview-window border-vertical \
  --layout=reverse \
  --margin=0,1 \
  --pointer='❯' \
  --prompt='❯ '"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Unset temp variables
unset FZF_COLORS
unset FZF_MOVEMENT

# ---

# TODO: Improve fzf keybindings
# - Home: Beginning of line
# - End:  End of line
# - Ctrl+Home: Beginning of search
# - Ctrl+End: End of Search

# TODO: Desired fzf widgets
# - Change Directory
# - Command History
# - Git Projects
# - Man Pages (Preview)

# Display fzf widget for 'cd' change directory
__fzf_cd() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf-tmux -1 -0 --no-sort --height=16 --reverse --toggle-sort=ctrl-r)" && cd "${dir}" || exit
  local ret=$?
  zle reset-prompt
  typeset -f zle-line-init > /dev/null && zle zle-line-init
  return $ret
}
# zle -N __fzf_cd
# bindkey '^[h' __fzf_cd

# Display fzf widget for user projects directory
__fzf_projects() {
  local dir
  dir="$()"
}
# zle -N __fzf_cd

# ZSH_FZF_PASTE_KEY="ctrl+v"
# ZSH_FZF_EXEC_KEY="enter"
# FZF_CMD=""

# # Display fzf widget for git log
# __fzf_git_log() {
#   [[ $(git status 2> /dev/null) ]] || return 0
#   local res=$(git log --graph --color=always \
#     --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" \
#   | FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}
#     --no-sort
#     --reverse
#     --tiebreak=index
#     --bind=\"${ZSH_FZF_PASTE_KEY}:execute@
#       echo {} | grep -o '[a-f0-9]\\\{7\\\}' | head -1@+abort\"
#     --bind=\"${ZSH_FZF_EXEC_KEY}:execute@
#       git show --color=always \$(echo {} | grep -o '[a-f0-9]\\\{7\\\}' | head -1) \
#       | less -R > /dev/tty@\"
#     " ${=FZF_CMD})
#   if [[ -n "$res" ]]; then
#     LBUFFER=$LBUFFER$res
#     zle redisplay
#   fi
# }
# zle -N __fzf_git_log

# # Display fzf widget for git diff
# __fzf_git_diff() {
#   preview="git diff $@ --color=always -- {-1}"
#   git diff $@ --name-only | fzf -m --ansi --preview "$preview"
# }
# zle -N __fzf_git_diff

alias fzp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --border --height='80%'"
