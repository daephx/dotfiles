# FZF Configuration
# shellcheck disable=SC1091

[ -n "$BASH_VERSION" ] && source "$XDG_CONFIG_HOME/fzf/fzf.bash"
[ -n "$ZSH_VERSION" ] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"

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
