# fabric: a modular framework for AI prompts.
# https://github.com/danielmiessler/fabric
# shellcheck disable=SC1091
# shellcheck shell=sh

# Do nothing if application is not available.
[ ! -x "$(command -v fabric)" ] && return

# Source the fabric bootstrap configuration if it exists.
FABRIC_CONFIG="${XDG_CONFIG_HOME:-$HOME./config}/fabric"
if [ -f "$FABRIC_CONFIG/fabric-bootstrap.inc" ]; then
  . "$FABRIC_CONFIG/fabric-bootstrap.inc"
fi
unset FABRIC_CONFIG
