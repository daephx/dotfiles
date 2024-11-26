#!/usr/bin/env sh
# Go: Managing Golang environment

# Set preferred directory for GOPATH
export GOPATH="${XDG_LOCAL_HOME:-$HOME/.local}/lib/go"

# Add go directories to PATH
if ! echo "$PATH" | grep -Eq "(^|:)/usr/local/go/bin($|:)"; then
  PATH="${PATH:+${PATH}:}/usr/local/go/bin"
fi

if ! echo "$PATH" | grep -Eq "(^|:)$GOPATH/bin($|:)"; then
  PATH="${PATH:+${PATH}:}$GOPATH/bin"
fi
