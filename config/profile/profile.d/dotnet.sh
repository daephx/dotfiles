# dotnet(1): The generic driver for the .NET CLI.
# shellcheck shell=sh

# Disable telemetry for .NET CLI
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Set the configuration directory for dotnet-cli
export DOTNET_CLI_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"/dotnet

# Set the configuration directory for OmniSharp
export OMNISHARPHOME="${XDG_CONFIG_HOME:-$HOME/.config}/omnisharp"

# Add .NET binary directory to PATH if it exists
# .NET creates its own directory in the user's home folder
# Default path: ~/.dotnet/dotnet
if [ -d "$DOTNET_DIR" ]; then
  export PATH="${PATH:+${PATH}:}$HOME/.dotnet"
fi
