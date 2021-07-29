#! /usr/bin/env bash
# -----------------------------------------------------------------------------
# https://github.com/chrisfcarroll/PowerShell-Bash-Dual-Script-Templates
# The top half of this script runs in Bash and the bottom half in Powershell
# Some lines at the end can run in both shells, but syntax common to both is
# limited.
# -----------------------------------------------------------------------------
#region    # * Pwsh <params> --------------------------------------------------
` # \
# PowerShell Param statement: every line must end in '#\' except the last line must with '<#\'
# And, you can't use backticks in this section        #\
Param( [Switch]$Standalone                            #\
)                                                    <#\ `
#endregion # * Pwsh <params> -------------------------------------------------
#region    # * Bash ----------------------------------------------------------
__ARGS="$@"
__SHELL="bash"
__ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__FILE="$(cd "$(basename "${BASH_SOURCE[0]}")" && pwd)"
set -e # stop execution if return not 0
echo "Platform: $OSTYPE"
echo ""
echo "Shell: $__SHELL"
echo "Args: $__ARGS"
echo "Cmd: $__SHELL $__FILE $__ARGS"
echo ""
echo "Dotfiles installation script: $(git remote get-url origin)"
echo ""

function main() {

  # ! these variables get overwritten by each source
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

  dotbot="${meta_dir}/dotbot/bin/dotbot"

  base_config_path="${meta_dir}/${BASE_CONFIG}${CONFIG_SUFFIX}"

  git submodule update --init --recursive
  parse_opts $@

  # Execute the returned stratagy
  # Default action is standalone configs: './install zsh'
  if [[ ! $STRAT ]] || [[ $STRAT == "profile" ]]; then parse_profiles "${POSITIONAL[@]}" && return 0; fi
  if [[ $STRAT == "standalone" ]]; then parse_standalone "${POSITIONAL[@]}" && return 0; fi

}

function parse_opts() {
  POSITIONAL=()
  while (($# > 0)); do
    case "${1}" in
    -p | --profile) STRAT="profile" && shift ;;
    -s | --standalone) STRAT="standalone" && shift ;;
    *) POSITIONAL+=("${1}") && shift ;;
    esac
    done
  set -- "${POSITIONAL[@]}" # restore positional params
}

function parse_standalone() {
  args=("$@")
  items=("$BASE_CONFIG" "${args[@]}")
  for config in "${items[@]}"; do
    echo "--- Configuration: $config ---"
    execute_command $config
    done
}

function parse_profiles() {
  while IFS= read -r config; do
    CONFIGS+=" ${config}"
    done <"${profile_dir}/$1"
  shift

  for config in ${CONFIGS} ${@}; do
    echo "--- Configuration: $config ---"
    execute_command $config
  done

}

function load_plugins() {
  plugins=()
  for plugin_dir in $plugins_dir/*; do
  plugin_name=$(basename "$plugin_dir")
  log debug "SEARCH\t| Directory: '$plugin_dir'"
    for file in $plugin_dir/*; do

      [ -f "$file" ] || continue

      basename=$(basename -- "$file")
      extension="${basename##*.}"
      filename="${basename%.*}"

      if [ "${filename}" = "${plugin_name}" ]; then
        plugin_path="$file"
        log debug "${GREEN}MATCH${RESET}\t| Loading: '$plugin_path'"
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
  log debug "Processing: $element"
  plug_d+=(-p "$element")
  done

  cmd=("${dotbot}" -d "${__root}")
  cmd=("${cmd[@]}" -c "${config_file}")
  cmd+=("${plug_d[@]}")

  if [[ $config == *"sudo"* ]]; then cmd=(sudo "${cmd[@]}"); fi

  log debug "Command Input: \n$ ${cmd[@]}\n"
  # IFS=' ' read -r -a plugins <<<"${cmd[@]}"
  # for i in "${plugins[@]}"; do
  #   echo "${i}"
  # done

  "${cmd[@]}"
  rm -f "$config_file"
}

# ! God this is a mess...
# Much like pythons: if __name__ == '__main__':
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
  # Import internal functions, patch them if unavalible
  INTERNAL="${XDG_LOCAL_HOME:-HOME/.local}/lib/internal.sh"
  [[ -e $INTERNAL ]] && source $INTERNAL || {
    include() { [[ -f $1 ]] && source "${XDG_LOCAL_HOME:-HOME/.local}/lib/$1"; }
    log() { [[ -z "$DEBUG" ]] && echo -e "${1^^}: ${2}" 1>&2; }
    log warn "internal library not defined or does not exist: '$INTERNAL'" 1>&2
  } && main "$@" # finally call the main function
fi

echo > /dev/null <<"out-null" ###
'@ | out-null
#>
#endregion # * Bash ----------------------------------------------------------
#region    # * Pwsh -----------------------------------------------------------
$ErrorActionPreference = "Stop" # Stop on first error
$__ARGS = $args
$__SHELL = "pwsh"
$__ROOT = $PSScriptRoot
$__FILE = $PSCommandPath
echo "Platform: $($PSVersionTable.OS)"
echo ""
echo "Shell: $__SHELL"
echo "Args: $__ARGS"
echo "Cmd: $__SHELL '$__FILE' $__ARGS"
echo ""
echo "Dotfiles installation script: $(git remote get-url origin)"
echo ""

$BaseConfig = "base"
$ConfigSuffix = "yaml"
$BaseConfigPath = "$__ROOT/meta/base.$ConfigSuffix"

# Default config file location
$ConfigPath = "$__ROOT/meta/profiles"
$ProfilePath = "$__ROOT/meta/profiles"
$PluginPath = "$__ROOT/meta/plugins"
$DotbotPath = "$__ROOT/meta/dotbot"
$DotbotBin = "$DotbotPath/bin/dotbot"

# Overwrite path if standalone flag was set
if ($Standalone) { $Path = "$__ROOT/meta/configs" }
else { $Path = "$__ROOT/meta/configs" }

# initialize command list
$Cmd = New-Object System.Collections.Generic.List[String[]]

# Parse matching config files from arguments
$ParsedConfig = Get-ChildItem -File -Path:$Path |
Where-Object {
  $_.Basename -in $__ARGS
} | Select-Object -ExpandProperty FullName

# Protect unix/windows from incompatible plugins
$IncompatiblePlugins = @("windows") # disable windows by default
if ($PSVersionTable.Platform -eq "Win32NT") {
  # activate if platform equals windows
  $WindowsCompatible = @("windows")
  # get list of plugins agains known windows compatibles
  $IncompatiblePlugins = @( Get-ChildItem -Path:$PluginPath |
  Where-Object { $_.name -notin $WindowsCompatible } |
  Select-Object -ExpandProperty Basename )
}

# Parse matching plugins from directory
$ParsedPlugins = Get-ChildItem -File -Depth 1 -Path:$PluginPath |
Where-Object {
  $_.BaseName -notin $IncompatiblePlugins -and
  $_.BaseName -eq (Get-Item (Split-Path -Parent $_)).basename
} | Select-Object -ExpandProperty FullName

# Construct command
$Cmd += "python " + $DotbotBin
$Cmd += "-d $__ROOT"
$Cmd += "-c $BaseConfigPath"
$Cmd += $ParsedConfig | ForEach-Object { "-c $_" }
$Cmd += $ParsedPlugins | ForEach-Object { "-p $_" }
$Cmd = ($Cmd -join " ") # Join them together

# Verbose command output
$Message = ($Cmd -split " ") | ForEach-Object { $i = 0 } { $i++ ; if (($i % 2) -eq 0) { Write-Host "$Last $_" } ; $Last = $_ }
Write-Verbose "$Message"

# Run the command
Invoke-Expression -Command:$Cmd

out-null
#endregion # * Pwsh -----------------------------------------------------------
#region    # * Both -----------------------------------------------------------
# -----------------------------------------------------------------------------
# Both Bash and Powershell run the rest but syntax common to both is limited
# -----------------------------------------------------------------------------
echo ""
echo "Installation script has completed, please refresh your terminal!"
echo ""
#endregion # * Both -----------------------------------------------------------
