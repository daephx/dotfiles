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

# Fix vim emulate Ctrl-key mappings
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line
bindkey "^W" backward-kill-word

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search
