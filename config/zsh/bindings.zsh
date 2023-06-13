### Bindings ###

# Disable stty bindings
stty quit ""
stty start undef # Disable Ctrl-q closing terminal
stty stop undef  # Disable Ctrl-s to freeze terminal
stty susp undef  # Disable Ctrl-Z to suspect process

# Set Vim-like binding mode
bindkey -v

# Set cursor for vi-mode
function zle-keymap-select () {
  case $KEYMAP in
    vicmd) echo -ne "\e[1 q";; # block
    viins|main) echo -ne "\e[5 q";; # beam
  esac
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
  echo -ne "\e[5 q"
}

zle -N zle-line-init
echo -ne "\e[5 q" # Use beam shape cursor on startup.
preexec() { echo -ne "\e[5 q" ;} # Use beam shape cursor for each new prompt.

# Fix backspace after vi escape
bindkey "^?" backward-delete-char

# Fix home and end key in vim terminal
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey -M vicmd "^[[H" beginning-of-line
bindkey -M vicmd "^[[F" end-of-line

# Fix vim emulate Ctrl-key mappings
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line
bindkey "^W" backward-kill-word

# Bindings for `v` is already mapped to visual mode, use `ctrl-v` to open Vim
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search # Arrow up
bindkey "^[[B" down-line-or-beginning-search # Arrow down

bindkey "^N" up-line-or-beginning-search # Ctrl-p
bindkey "^P" down-line-or-beginning-search # Ctrl-n

# Ctrl-Arrow to jump words
bindkey "^[[1;5C" forward-word # Arrow right
bindkey "^[[1;5D" backward-word # Arrow left

# Navigate completion menu using “hjkl”
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
