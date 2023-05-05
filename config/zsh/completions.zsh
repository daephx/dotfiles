### Completions ###

autoload -Uz compinit
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zccompdump"
_comp_options+=(globdots) # Include hidden files.

### Styles ###

zle_highlight=('paste:none')

## case-insensitive (uppercase from lowercase) completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' menu select
# zstyle ':completion::complete:lsof:*' menu yes select

# Tab completion colors
# zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS} "ma=16;5;244;2"
zstyle ':completion:*:options' list-colors '=^(-- *)=34'

autoload -Uz colors && colors

