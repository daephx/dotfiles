#! /usr/bin/env bash
# -----------------------------------------------------------------------------
# https://github.com/chrisfcarroll/PowerShell-Bash-Dual-Script-Templates
# The top half of this script runs in Bash and the bottom half in Powershell.
# Some lines at the end can run in both shells, but common syntax is limited.
# -----------------------------------------------------------------------------
#region    # * Pwsh <params> --------------------------------------------------
` # \ PowerShell Parameters:
# Every line must end in '#\' the last line ends in '<#\'
# You cannot use backticks in this section!           #\
Param( [Alias("s")]                                   #\
       [Switch]$Standalone                            #\
)                                                    <#\`
#endregion # * Pwsh <params> -------------------------------------------------
#region    # * Bash ----------------------------------------------------------
set -e # stop execution if return not 0
echo "Dotfiles install script: $(git remote get-url origin)"
echo "Platform: $OSTYPE"
echo "Shell: bash"
echo ""

# Define colors
RESET='\e[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

function main() {
  __root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  __file=$(basename "${BASH_SOURCE[0]}")
  __local="${XDG_LOCAL_HOME:-HOME/.local}"
  __lib="${__local}/lib"

  BASE_CONFIG="base"
  CONFIG_SUFFIX=".yaml"

  meta_dir="${__root}/meta"
  config_dir="${meta_dir}/configs"
  profile_dir="${meta_dir}/profiles"
  plugins_dir="${meta_dir}/plugins"
  scripts_dir="${meta_dir}/scripts"
  base_config_path="${meta_dir}/${BASE_CONFIG}${CONFIG_SUFFIX}"
  dotbot="${meta_dir}/dotbot/bin/dotbot"

  log info "Ensuring dotbot submodule is initialized..."
  git submodule update --init --recursive -- meta/dotbot

  # Parse command line arguments
  parse_opts $@

  # Execute the returned strategy
  # Default action is standalone configs: './install zsh'
  if [[ ! $STRAT ]] || [[ $STRAT == "profile" ]]; then parse_profiles "${POSITIONAL[@]}" && return 0; fi
  if [[ $STRAT == "standalone" ]]; then parse_standalone "${POSITIONAL[@]}" && return 0; fi
  if [[ $STRAT == "docker" ]]; then parse_docker; fi
}

function parse_opts() {
  POSITIONAL=()
  while (($# > 0)); do
    case "${1}" in
    -p | --profile) STRAT="profile" ;;
    -s | --standalone) STRAT="standalone" ;;
    -D | --docker) STRAT="docker" ;;
    *) POSITIONAL+=("${1}") ;;
    esac
    shift
  done
  set -- "${POSITIONAL[@]}" # restore positional params
}

function parse_standalone() {
  args=("$@")
  items=("$BASE_CONFIG" "${args[@]}")
  for config in "${items[@]}"; do
    log info "Initializing dotbot config: $config"
    execute_command $config
    done
}

function parse_profiles() {
  while IFS= read -r config; do
    CONFIGS+=" ${config}"
    done <"${profile_dir}/$1"
  shift

  for config in ${CONFIGS} ${@}; do
    log info "Initializing dotbot profile: $config"
    execute_command $config
  done
}

function parse_docker() {
  docker build -t docker.daephx/dotfiles .
  ID=$(
      docker images --format="{{.Repository}} {{.ID}}" |
      grep "docker.daephx/dotfiles" |
      cut -d' ' -f2
  ); docker run -it $ID
}

function load_plugins() {
  plugins=()
  for plugin_dir in $plugins_dir/*; do
  plugin_name=$(basename "$plugin_dir")
    for file in $plugin_dir/*; do

      [ -f "$file" ] || continue

      basename=$(basename -- "$file")
      extension="${basename##*.}"
      filename="${basename%.*}"

      if [ "${filename}" = "${plugin_name}" ]; then
        plugin_path="$file"
        log debug "${GREEN}MATCH${RESET} | Plugin: '$plugin_path'"
        plugins+=("${plugin_path}")
      fi
    done
  done
  echo "${plugins[@]}"
}

function execute_command() {

  config_file="$(mktemp)" # create temporary file
  suffix="-sudo"
  config_path="${config_dir}/${config%"$suffix"}${CONFIG_SUFFIX}"

  if [[ $config == "base" ]]; then config_path="${base_config_path}"; fi

  echo -e "$(<"${config_path}")" >"$config_file"

  plug_d=()
  IFS=' ' read -r -a plugins <<<"$(load_plugins)"
  for element in "${plugins[@]}"; do
  plug_d+=(-p "$element")
  done

  cmd=("${dotbot}" -d "${__root}")
  cmd=("${cmd[@]}" -c "${config_file}")
  cmd+=("${plug_d[@]}")

  # Run config file as sudo if prefixed
  # Example: sudo-docker.yaml
  if [[ $config == *"sudo"* ]]; then cmd=(sudo "${cmd[@]}"); fi

  # Execute command string
  # "${cmd[@]}"

  echo "${cmd[@]}"

  # Delete temp config file
  rm -f "$config_file"
}

log() { [[ -n "$DEBUG" ]] && echo -e "${1^^}:\t${2}" 1>&2; }

# Much like pythons: if __name__ == '__main__':
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
  main "$@" # call the main function
fi

# Do not touch...
echo > /dev/null <<"out-null" ###
'@ | out-null
#>
#endregion # * Bash ----------------------------------------------------------
#region    # * Pwsh -----------------------------------------------------------
$ErrorActionPreference = "Stop" # Stop on first error
Write-Output "Dotfiles install script: $(git remote get-url origin)"
Write-Output "Platform: $($PSVersionTable.OS)"
Write-Output "Shell: pwsh"

# Default config file location
$ConfigPath = "$PSScriptRoot/meta/configs"
$ProfilePath = "$PSScriptRoot/meta/profiles"
$PluginPath = "$PSScriptRoot/meta/plugins"
$DotbotPath = "$PSScriptRoot/meta/dotbot"
$DotbotBin = "$DotbotPath/bin/dotbot"
$BaseConfigPath = "$PSScriptRoot/meta/base.yaml"

# Overwrite path if standalone flag was set
if ($Standalone) { $SearchPath = $ConfigPath }
else { $SearchPath = $ProfilePath }

# initialize command list
$Cmd = New-Object System.Collections.Generic.List[String[]]

# Parse matching config files from arguments
$ScriptArguments = $args
$ParsedConfig = Get-ChildItem -File -Path:$SearchPath | Where-Object {
  $_.BaseName -in $ScriptArguments
} | Select-Object -ExpandProperty FullName

# Parse matching plugins from directory
$ParsedPlugins = Get-ChildItem -File -Depth 1 -Path:$PluginPath |
Where-Object {
  $_.BaseName -eq (Get-Item (Split-Path -Parent $_)).basename
} | Select-Object -ExpandProperty FullName

# Construct command
$Cmd += "python " + $DotbotBin
$Cmd += "-d $PSScriptRoot"
$Cmd += "-c $BaseConfigPath"
$Cmd += $ParsedConfig | ForEach-Object { "-c $_" }
$Cmd += $ParsedPlugins | ForEach-Object { "-p $_" }
$Cmd = ($Cmd -join " ") # Join them together

# Verbose command output
$Message = ($Cmd -split " ") |
ForEach-Object { $i = 0 } { $i++ ; if (($i % 2) -eq 0) { "$Last $_" } ; $Last = $_ }
Write-Verbose "$Message"

# Evaluate command string
Invoke-Expression -Command:$Cmd

Out-Null
#endregion # * Pwsh -----------------------------------------------------------
#region    # * Both -----------------------------------------------------------
# -----------------------------------------------------------------------------
# Both Bash and Powershell run the rest but syntax common to both is limited
# -----------------------------------------------------------------------------
echo ""
echo "Installation script complete!"
echo ""
#endregion # * Both -----------------------------------------------------------
