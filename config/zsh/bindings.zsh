# zsh/bindings: Keyboard binding options for zsh(1)

# Make Vi mode transitions faster (hundredths of a second)
export KEYTIMEOUT=15

# Load the complist module to enable enhanced scrollable menus
# NOTE: This is required for menuselect bindings to function properly.
zmodload zsh/complist

# Disable stty bindings
stty quit ""
stty start undef # Disable Ctrl-q closing terminal
stty stop undef  # Disable Ctrl-s to freeze terminal
stty susp undef  # Disable Ctrl-Z to suspect process

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Set Vim-like binding mode
bindkey -v

# Reset cursor on prompt initialization
zle-line-init() { echo -ne "\e[5 q"; }
zle -N zle-line-init

# Set cursor depending on the current vi-mode
function zle-keymap-select () {
  case $KEYMAP in
    vicmd) echo -ne "\e[1 q";; # block
    viins|main) echo -ne "\e[5 q";; # beam
  esac
}
zle -N zle-keymap-select

# Edit command buffer in EDITOR using `ctrl-v`
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

# Fix backspace after vi escape
bindkey "^?" backward-delete-char

# Fix vim emulate Ctrl-key mappings
# HACK: After pasting in vi mode, the default binding doesn't work
bindkey '^U' backward-kill-line
bindkey -M vicmd '^H' backward-char
bindkey -M viins '^H' backward-delete-char

# Yank to end-of-line
bindkey -M vicmd 'Y' vi-yank-eol

# Better undo/redo bindings
bindkey -M vicmd "^r" redo
bindkey -M vicmd "u" undo

# Fix home and end key in vim terminal
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey -M vicmd "^[[H" beginning-of-line
bindkey -M vicmd "^[[F" end-of-line

# Ctrl-Arrow to jump words
bindkey "^[[1;5C" forward-word # Arrow right
bindkey "^[[1;5D" backward-word # Arrow left

bindkey -M vicmd "^[[1;5C" forward-word # Arrow right
bindkey -M vicmd "^[[1;5D" backward-word # Arrow left

# Cycle command history with Ctrl-up/down
bindkey "^[[A" up-line-or-beginning-search # Arrow up
bindkey "^[[B" down-line-or-beginning-search # Arrow down

# Cycle command history with Ctrl-n/p
bindkey "^N" up-line-or-beginning-search
bindkey "^P" down-line-or-beginning-search

# Use ctrl-j/k to navigate history
bindkey "^k" up-line-or-beginning-search
bindkey "^j" down-line-or-beginning-search

# Navigate completion menu using “hjkl”
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char

# Navigate completion menu backwards with shift-tab
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Prepend sudo to the current command buffer.
function prepend-sudo() {
  if [[ $BUFFER != "sudo "* ]]; then
    BUFFER="sudo $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-sudo
bindkey "^x^s" prepend-sudo
bindkey -M vicmd "^x^s" prepend-sudo

# Insert the output from last command into the command buffer.
zmodload -i zsh/parameter
function insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey "^[l" insert-last-command-output
bindkey -M vicmd "^[l" insert-last-command-output

# Insert the output from the last commands in a new $EDITOR instance.
function edit-last-command-output() {
  local last_output=$(eval "$history[$((HISTCMD-1))]")
  local temp_file=$(mktemp /tmp/last_command_output.XXXXXX)
  echo "$last_output" > "$temp_file"
  ${EDITOR:-vi} "$temp_file"
  rm -f "$temp_file" &>/dev/null
}
zle -N edit-last-command-output
bindkey "^[L" edit-last-command-output
bindkey -M vicmd "^[L" edit-last-command-output
