# zsh/completion: Completion options for zsh(1)

# Create cache directory
zcachedir="${XDG_CACH_HOME:-$HOME/.cache}/zsh/cache"
[ -d "$zcachedir" ] || mkdir -p "$zcachedir" > /dev/null

# Load/Initialize completion modules
autoload -Uz compinit && compinit -d "$zcachedir/zcompdump"
autoload -Uz colors && colors
zmodload zsh/complist

# Set cdpath for easy location list
cdpath=("." "$HOME")

# Add local completions to fpath
fpath=("$XDG_DATA_HOME/zsh/completion" $fpath)

# Include hidden files in completion
_comp_options+=(globdots)

# Display highlight of pasted text
zle_highlight=('paste:none')

# Enable caching for completion items
zstyle ':completion:*' cache-path "$zcachedir"
zstyle ':completion:*' use-cache on

# Always show the auto-completion list if ambiguous
zstyle ':completion:::::default' menu yes select

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Force prefix matching
zstyle ':completion:*' accept-exact '*(N)'

# List directories first
zstyle ':completion:*' list-dirs-first true

# Group matches
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*' group-name ''

# Partial completion suggestions
# Allow complete path via fragments: /p/t/dir
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix 

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Completion messages
zstyle ':completion:*:messages' format $'\e[01;35m[%d]\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m[No Matches Found]\e[0m'

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Show only local folders while cdpath is defined
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'local-directories named-directories'

# Show Makefile targets
zstyle ':completion::complete:make::' tag-order targets variables

# Fzf-Tab

# Switch between completion groups with vim style bindings
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'

# HACK: Query highlight not being applied from FZF_DEFAULT_OPTS
# This explicitly sets the highlight color but this feels like a bug.
zstyle ':fzf-tab:*' fzf-flags '--color=hl:6'

# Set group prefix character
zstyle ':fzf-tab:*' prefix ''

# Preview directory's content with ls/eza when completing cd
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
if command -v eza > /dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -l --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -l --color=always $realpath'
fi
