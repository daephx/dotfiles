### Bindings ###

stty start undef # Disable Ctrl-q closing terminal
stty stop undef # Disable Ctrl-s to freeze terminal

# Set Vim-like binding mode
bindkey -v

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "\e" kill-whole-line

bindkey "^j" down-line-or-beginning-search # Down
bindkey "^k" up-line-or-beginning-search   # Up
bindkey "^n" down-line-or-beginning-search # Down
bindkey "^p" up-line-or-beginning-search   # Up

# Cycle through history based on characters already typed on the line
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search
