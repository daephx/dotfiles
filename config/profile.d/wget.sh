# WGet Settings
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export WGETHIST="$XDG_CACHE_HOME/wget/history"
alias wget="wget --hsts-file \$WGETHIST"
