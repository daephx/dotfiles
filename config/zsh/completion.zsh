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

# Navigate completion menu using “hjkl”
zstyle ':completion:*' menu select

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'

# Highlight the current autocomplete option
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Force prefix matching
zstyle ':completion:*' accept-exact '*(N)'

# partial completion suggestions
# Allow complete path via fragments: /p/t/dir
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix 

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# List directories first
zstyle ':completion:*' list-dirs-first true

# Join double slashes in completion
zstyle ':completion:*' squeeze-slashes true

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

# Use tmux-pane for completion list
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# Switch between completion groups with vim style bindings
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'

# Preview directory's content with ls/exa when completing cd
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
command -v exa > /dev/null && {
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -l --color=always $realpath'
} || {
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -l --color=always $realpath'
}
