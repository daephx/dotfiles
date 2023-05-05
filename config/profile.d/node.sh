# Node config
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
if [ -f "$NPM_CONFIG_USERCONFIG" ]; then
  export PATH="$PATH:$XDG_DATA_HOME/npm/bin"
fi
