# Fzf: A command-line fuzzy finder
# https://github.com/junegunn/fzf
# shellcheck disable=SC1091

# Add fzf/bin directory to PATH
if [[ -d $XDG_DATA_HOME/fzf/bin ]] \
  && [[ ! "$PATH" == *$XDG_DATA_HOME/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$XDG_DATA_HOME/fzf/bin"
fi

# Do nothing if application is not available.
[ ! -x "$(command -v fzf)" ] && return

# Initialize fzf shell integrations
[ -n "$BASH_VERSION" ] && eval "$(fzf --bash)"
[ -n "$ZSH_VERSION" ] && eval "$(fzf --zsh)"

# Extra options
export FZF_DEFAULT_COMMAND="rg -uu --files -H"
export FZF_ALT_COMMAND="fd -uu -t f"
export FZF_COMPLETION_TRIGGER="**"

export FZF_DEFAULT_OPTS="
--info=inline
--layout=reverse
--margin=0,1
--pointer='❯'
--preview-window border-left
--prompt='❯ '
--separator=''
--color=dark
--color=bg+:234
--color=bg:-1
--color=border:238
--color=fg+:15
--color=fg:8
--color=gutter:-1
--color=header:3
--color=hl+:3
--color=hl:6
--color=info:5
--color=marker:6
--color=pointer:3
--color=preview-fg:7
--color=prompt:4
--color=spinner:3
--bind='change:first'
--bind='alt-a:toggle-all'
--bind='alt-d:preview-half-page-down'
--bind='alt-g:ignore'
--bind='alt-h:backward-char+refresh-preview'
--bind='alt-l:forward-char+refresh-preview'
--bind='alt-p:toggle-preview'
--bind='alt-s:toggle-sort'
--bind='alt-u:preview-half-page-up'
--bind='alt-y:yank'
--bind='ctrl-d:preview-half-page-down'
--bind='ctrl-l:clear-screen'
--bind='ctrl-u:half-page-up+refresh-preview'
--bind='ctrl-u:unix-line-discard'
--bind='end:last'
--bind='home:first'
--bind='pgdn:half-page-down+refresh-preview'
--bind='pgup:half-page-up+refresh-preview'
"

# CTRL-/ | Toggle small preview window to see the full command
# CTRL-Y | Copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
--header 'Press CTRL-Y to copy command into clipboard'
--color header:italic
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--preview 'echo {}' --preview-window up:3:hidden:wrap
"
