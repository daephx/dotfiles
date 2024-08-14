# zsh/completion: Completion options for zsh(1)

# Create cache directory
zcachedir="${XDG_CACH_HOME:-$HOME/.cache}/zsh/cache"
zcompdump="$zcachedir/zcompdump"
[ -d "$zcachedir" ] || mkdir -p "$zcachedir" > /dev/null

# Add local completions to fpath
fpath=("$XDG_DATA_HOME/zsh/completion" $fpath)

# Load/Initialize completion modules
autoload -U +X bashcompinit && bashcompinit
autoload -Uz colors && colors
autoload -Uz compinit
zmodload zsh/complist

# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticeable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
if [[ -n ${zcompdump}(#qN.mh+24) ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

# Include hidden files in completion
_comp_options+=(globdots)

# Set cdpath for easy location list
cdpath=("." "$HOME")

# Display highlight of pasted text
zle_highlight=('paste:none')

# Enable caching for completion items
zstyle ':completion:*' cache-path "$zcachedir"
zstyle ':completion:*' use-cache true

# Always show the auto-completion list if ambiguous
zstyle ':completion:::::default' menu true select

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'

# Highlight the current autocomplete option
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Force prefix matching
zstyle ':completion:*' accept-exact '*(N)'

# List directories first
zstyle ':completion:*' list-dirs-first true

# Disable completion for special directories . and ..
zstyle ':completion:*' special-dirs false

# Group matches
zstyle ':completion:*:matches' group true
zstyle ':completion:*' group-name ''

# Partial completion suggestions
# Allow complete path via fragments: /p/t/dir
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix 

# Join double slashes in completion
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion::complete:*' '\\'

# Set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'

# Completion messages
zstyle ':completion:*:messages' format $'\e[01;35m[%d]\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m[No Matches Found]\e[0m'

# Exclude system users from completion
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
  clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
  gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
  ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
  operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
  usbmux uucp vcsa wwwrun xfs '_*'

# Set process completion for Solaris OS
if [[ "$OSTYPE" = solaris* ]]; then
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm"
else
  zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
fi

# Completion options for kill/processes
compdef pkill=kill
compdef pkill=killall
zstyle ':completion:*:*:kill:*' menu true select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:processes' command 'ps -au$USER'

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# Disable named-directories autocompletion
zstyle ':completion:*:(cd|pushd):*' tag-order \
  local-directories directory-stack path-directories

# Disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# Show Makefile targets
zstyle ':completion::complete:make::' tag-order targets variables

# Fzf-Tab
# https://github.com/Aloxaf/fzf-tab
# Set options for this plugin for fzf interop with zsh completions.
# NOTE: fzf-tab needs to be loaded after compinit, but before plugins which will
# wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting

# Switch between completion groups with vim style bindings
zstyle ':fzf-tab:*' switch-group 'ctrl-h' 'ctrl-l'

# HACK: Query highlight not being applied from FZF_DEFAULT_OPTS
# This explicitly sets the highlight color but this feels like a bug.
zstyle ':fzf-tab:*' fzf-flags '--color=hl:6'

# Set group prefix character
zstyle ':fzf-tab:*' prefix ''

# Show preview for systemd unit status
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Preview directory's content with ls/eza when completing cd
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
if command -v eza > /dev/null; then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -l --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -l --color=always $realpath'
fi
