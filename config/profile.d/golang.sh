# Go settings
export GOPATH="$XDG_LOCAL_HOME/lib/go"

if ! echo "$PATH" | grep -Eq "(^|:)/usr/local/go/bin($|:)"; then
  export PATH="$PATH:/usr/local/go/bin"
fi
if ! echo "$PATH" | grep -Eq "(^|:)$GOPATH/bin($|:)"; then
  export PATH="$PATH:$GOPATH/bin"
fi
