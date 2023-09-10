# Disable telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Dotnet creates it's own directory in the users home folder.
# The dotnet binary path is: ~/.dotnet/dotnet
if [ -d "$DOTNET_DIR" ]; then
  PATH="${PATH:+${PATH}:}$HOME/.dotnet"
fi
