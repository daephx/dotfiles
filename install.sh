#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# ─────────────────────────────────────────────────────────────────────────────
# FILE: install.sh
#
# USAGE: install.sh [--help] [-y] [-r <url>] [-p <path>] [-oD logfile]
#
# DESCRIPTION: List and/or delete all stale links in directory trees.
# The default starting directory is the current directory.
# Don't descend directories on other filesystems.
# ~ Compatible with bash and dash/POSIX
#
# DEPENDS: git
# AUTHOR: Daephx
# VERSION: 0.2.2
# CREATED: 2021-04-04 - 03:36:51
# ─────────────────────────────────────────────────────────────────────────────

function usage() {
    echo -e "$(
        cat <<EOF
─────────────────────────────────────────────────────────────────────────────────

${WHITE}Usage: $(basename "${BASH_SOURCE[0]}") [--help] [-y] [-r <url>] [-p <path>] [-oD logfile]${RESET}

${RESET}$_NAME v$_VERSION - $_ORG [$_TM] : ~~Compatible with bash and dash/POSIX${RESET}~~

${WHITE}Commands:${BBLACK}
${BBLACK}        --help          ${WHITE}Print the help message${RESET}
${BBLACK}  -v, | --version       ${WHITE}Print script version info${RESET}

${BBLACK}  bootstrap             ${WHITE}Overwrite \$HOME files with symbolic links${RESET}          ${ON_PURPLE}# TODO${RESET}
${BBLACK}  gitconfig             ${WHITE}Check for gitconfig file & if not, create it${RESET}       ${ON_PURPLE}# TODO${RESET}
${BBLACK}  update                ${WHITE}Process common updates${RESET}                             ${ON_PURPLE}# TODO${RESET}

${WHITE}Options:${RESET}
${BBLACK}        --debug         ${WHITE}Print script version info${RESET}
${BBLACK}        --verbose       ${WHITE}Print script debug info${RESET}
${BBLACK}  -y, | --yes           ${WHITE}Automatically accept confirmation prompts${RESET}

${WHITE}Inputs:${BBLACK}
${BBLACK}  -r, | --repo   <str>  ${WHITE}Repository URL${RESET}
${BBLACK}  -p, | --path   <str>  ${WHITE}Destination path to clone the repo${RESET}
${BBLACK}  -o, | --output <str>  ${WHITE}Optonal path for logging to file${RESET}                   ${ON_PURPLE}# TODO${RESET}

─────────────────────────────────────────────────────────────────────────────────
EOF
    )" # this cannot not be on the EOF line
    exit 1
}

function _main() {

    # trap "cleanup" EXIT INT SIGINT
    # set -e # stop execution if return not 0
    # set -Eeuo pipefail

    _VERSION="0.2.2"
    _NAME="SymDot"
    _AUTHOR="daephx"
    _ORG=$_AUTHOR
    _TM=$(date +%Y)
    TIMESTAMP=0 # timstamp on log output
    LOGLEVEL=2  # Default Log Level | 2:INFO
    FILELABEL=1 # prepends the filename to log output
    TIMESTAMP=0 # Display a timestamp in the log output

    # default values of variables set from params
    bypass_mode=0 # whether the script should halt for user input
    killerrors=1  # enable terminating error messages
    setup_colors  # assign color codes to variables
    argument_parser "$@"

    debug "All default variables have been loaded"
    info "Starting application: $_NAME v$_VERSION"

    confirm
    return
    # if ! [[$REPOURL]] && ! [[$dotfiles_location]]; then error "oof, can't do notin without yer arguments there sonny."; fi
    # debug "Environement Variable: ENVIRONMENT:development, Loading settings..."

    warn "\n${YELLOW}This script is a work in progress, ${RED}use at your own risk!${RESET}"
    prompt "Press ENTER to continue, Ctrl+C to cancel..."
    info "Starting installation process..."
    sleep 3

    # file_config_providor $CLONEPATH # check data providers $1 || (.env)
    install_dependencies

    # confirm
    return

    if ! [[ -f ".gitconfig.local.symlink" ]]; then setup_gitconfig; fi
    if ! [[ -d "$CLONEPATH" ]]; then clone_dotfiles $CLONEPATH; fi
    debug "Change directory to installation path: '$CLONEPATH'"
    cd "$CLONEPATH"

    sleep 3
    info "Installation Process complete..."

}

function argument_parser() {

    # Ok, listen to me...
    # First we initalize the params variable, we do this so that it can be parsed.
    # we are expecting a string like this:

    #     "--debug --repo-url https://.../ --path /tmp/$_NAME"

    # With the paramaters in this format we will split them by the number of spaces.  The issue I'm
    # having is that some cli applications are diffrent with thier strings.  Part of this could be
    # my windows background but there are cases where things come in within quotations or
    # , where they are not as easily split.
    #
    #   "--repo=http://.../", "--path=/tmp/$_NAME"
    #
    # To remedy this, I wish to preprocess the strings, but finding the route has been difficult...
    # .*gasp*. Alright, so I think all the arguments are initialized at runtime and the parser is
    # already iterating the list; the list seems to change with scope but is it a list
    # "$1","$2", "$3", "$4" ...

    PARAMS=""
    while (($#)); do
        debug "Argument Parser: evaluating argument case: '$1'"
        split=$(split_equalsign_arguments $1)
        case "$1" in

        update)
            debug "Argument Parser: command spotted 'update': Activating update process"
            echo sudo apt-get update -qq
            exit
            ;;

        bootstrap)
            debug "Argument Parser: command spotted 'bootstrap': Activating bootstrap script"
            file="$(dirname "${BASH_SOURCE[0]}")/bootstrap.sh"
            info "Argument Parser: Activating '$file'"
            source "$file"
            _main
            exit
            ;;

        gitconfig)
            debug "Argument Parser: command spotted 'gitconfig': Activating gitconfig generator"
            out "im a devloper"
            error "gitconfig script is not yet trusted, stopping execution."
            # setup_gitconfig
            exit
            ;;

        -v | --version)
            out "$_NAME v$_VERSION"
            exit
            ;;
        --debug)
            LOGLEVEL=1
            TIMESTAMP=1
            debug "Argument Parser: flag spotted '--debug': Activating debug mode 'LOGLEVEL=$LOGLEVEL'"
            ;;
        --verbose)
            set -x
            debug "Argument Parser: flag spotted '--verose': Activating verbose mode  'set -x'"
            ;;
        -y | --yes)
            YES=1
            debug "Argument Parser: flag spotted '--yes': Bypassing user prompts 'YES=$YES'"
            ;;
        --repo)
            url=$2
            url_validator $url
            dotfiles_repository=$url
            debug "Argument Parser: command called '--repo' command called; output: '$url'"
            shift
            ;;
        --path)
            path=$2
            path_validator $path
            dotfiles_location=$path
            debug "Argument Parser: '--path' command called; output: '$path'"
            shift
            ;;
        --help)
            usage
            ;;
        ?*) error "Argument Parser: ${RED}Unknown option${RESET}: '$1'" ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            debug "Argument Parser: Reattaching Paramas \"$PARAMS\" | \"{$1: $2: $3: $4}\""
            shift
            ;;
        esac
        shift
    done

    if [[ "$PARAMS" == "" ]]; then usage; fi # Display help and exit if no paramaters given
    # set positional arguments in their proper place
    eval set -- "$PARAMS" # !IMPORTANT ?? maybe
    debug "Argument Parser: Evaluated Parameter list: '$PARAMS'"

    # error "he's dead jim..." # error terminates the script

    # word is the empty string, and the colon is omitted. Without the colon, the check is just for
    # unset, but not for null, so ${uno-} is equivalent to checking if uno is set '${parameter:-word}'

    debug "Argument Parser: Aquired parameters:\n\n\t--repo: $dotfiles_repository\n\t--path: $dotfiles_location\n"

    # if no arguments were provided.
    # args=("$@")
    # if [[ ${#args[@]} -eq 0 ]]; then usage; fi
    # check variable assignment for required arguments
    [[ -z "${dotfiles_repository-}" ]] && error "Argument Parser: ${RED}Missing required parameter${RESET}: '--repo <url>' | https://githost.tld/<user>/dotfiles.git"
    [[ -z "${dotfiles_location-}" ]] && error "Argument Parser: ${RED}Missing required parameter:${RESET} '--path <str>' | /tmp/dotfiles/"

    return 0
}

function evaluate_argument_string() {

    previous_argument=0 # TODO
    # [[ "$1" == "-.+=" ]] &&
    if ! [[ "$1" =~ "-.+=(.+)" ]]; then return; fi
    debug "Attmpted split_argument on string $1\n\n\t${BASH_REMATCH[1]}"
    printf "$1" 1>&1
}

function split_equalsign_arguments() {
    # [[ "$1" == "-.+=" ]] &&
    if ! [[ "$1" =~ "-.+=(.+)" ]]; then return; fi
    debug "Attmpted split_argument on string $1\n\n\t${BASH_REMATCH[1]}"
    printf "$1" 1>&1
}

function url_validator() {
    string="$1"
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    default_log="String Validators: URL: Attempted MATCH"
    if [[ $string =~ $regex ]]; then
        debug "$default_log [${GREEN}GOOD${RESET}] w/ '$string'"
    else error "$default_log [${RED}FAIL${RESET}] w/ '$string'"; fi
}

function path_validator() {
    string="$1"
    regex="^/|//|(/[\w-]+)+$"
    default_log="String Validators: PATH: Attempted MATCH "
    if [[ $string =~ $regex ]]; then
        debug "$default_log [${GREEN}GOOD${RESET}] w/ '$string'"
    else error "$default_log [${RED}FAIL${RESET}] w/ '$string'"; fi
}

function setup_gitconfig() {
    if ! [[ -f git/gitconfig.local.symlink ]]; then
        debug "GitConfigInit: File Exists 'git/gitconfig.local.symlink'"
        git_credential="cache"
        if [[ "$(uname -s)" == "Darwin" ]]; then
            git_credential="osxkeychain"
            debug "GitConfigInit: 'uname -s' resolved to 'Dawrin', git_credential set to 'osxkeychain'"
        fi

        out " * What is your github author name?"
        read -e git__AUTHOR
        out " * What is your github author email?"
        read -e git_authoremail

        sed \
            -e "s/_AUTHOR/$git__AUTHOR/g" \
            -e "s/AUTHOREMAIL/$git_authoremail/g" \
            -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" \
            git/gitconfig.local >git/gitconfig.local.symlink

        info "Gitconfig Setup: Successfully created file: 'git/gitconfig.local.symlink'"
    fi
}

# function get_basic_credentials() {
#   # '-s' option prevents the user's typing from appearing in the terminal,
#   read -p "Enter your username: " username
#   read -sp "Enter your password: " password
#   echo
# }

install_oh-my-zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function update_system() {
    info "Updating system..."
    sudo apt-get update -qq # -qq will hide stdout

    # insatll/update general system packages
    sudo apt-get install -yy htop
    sleep 3
}

function install_dependencies() {
    info "Installing packages..."
    sleep 3
}

function github_latest_release() {
    # v0.31.4 : https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c
    # Usage:    $ get_latest_release "creationix/nvm"
    # This will curl the output into the current directory
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
        grep '"tag_name":' |                                          # Get tag line
        sed -E 's/.*"([^"]+)".*/\1/'                                  # Pluck JSON value
}

function clone_dotfiles() {

    # Inputs: PATH <STRING>
    #   clone_dotfiles only takes in a path destination
    #   the rest is supplised by global variables atm.

    if [[ -f "$1" ]]; then
        error "It appears that the provided path already exists.\n\n${RED}Conflict:${BBLACK} '$1'"
    fi
    # info "Installing dotfiles..."
    git clone --recursive $REPOURL $CLONEPATH # Clone the repo
    cd "$CLONEPATH"                           # enter the .dotfile repo
}

function file_config_providor() {
    if [ "$1" == "" ] || [ "$#" -gt 1 ]; then           # check for script paramaters
        if ! [ -f ".env" ] || ! [ -z $CLONEPATH ]; then # check for environment variables
            error "The script could not determin a sutible path to clone the repository.
-------------------------------------------------------------------------------
${UWHITE}Please either use the remote install command:\n
  ${BBLACK}$ ${GREEN}wget -O - https://raw.githubusercontent.com/daephx/dotfiles/main/install.sh | bash${RESET}\n
${UWHITE}or, clone the repository and modify the .env variables:\n
  ${BBLACK}$ ${GREEN}git clone https://github.com/daephx/dotfiles.git ~/.dotfiles && bash ~/.dotfiles/install.sh${RESET}\n
-------------------------------------------------------------------------------"
        else
            # Environment variable was been found
            debug "Configuration provider: 'Environment Variable'"
            export $(cat .env | xargs) 1>&/dev/null # environment variable injection (.env)
        fi
    else
        # Script parameter was provided
        debug "Configuration provider: 'Script Paramater'"
    fi
    info "Starting with path: '$CLONEPATH'"
}

function confirm() {

    default_string=$1

    if [[ $bypass_mode ]]; then return 0; fi # quick stop if active
    if ! [[ $default_string ]]; then error "User Confirmation: Default string was not supplied. '$default_string'"; fi

    printf "$1\n\n"

    echo -n "Do you wish to continue? [y/n]: "
    while true; do
        read -e yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*) exit ;;
        *)
            # echo -en "\033[1A\033[2K"
            echo -ne "\rPlease answer yes or no. [y/n]: "
            ;;
        esac
    done
}

function prompt() {

    # - log " * What is your github author email?"
    # + out " * What is your github author email?"
    #   read -e git_authoremail

    printf "$(read -p "$1")\n" 1>&1
}

# Logging functions
function error() { out "$1" 4; }
function warn() { out "$1" 3; }
function info() { out "$1" 2; }
function debug() { out "$1" 1; }
function out() {

    local msg="$1" # STRING
    local lvl="$2" # 0, 1, 2, 3, 4

    if [[ "$lvl" -lt "$LOGLEVEL" ]] && [[ "$lvl" -ne 0 ]]; then return; fi

    case "$2" in
    4) level_label="${RED}ERR${RESET}" ;;    # Error
    3) level_label="${YELLOW}WRN${RESET}" ;; # Warning
    2) level_label="${WHITE}INF${RESET}" ;;  # Info
    1) level_label="${CYAN}DBG${RESET}" ;;   # Debug
    *) ;;                                    # General
    esac

    default_output_string="${RESET}$1${RESET}"
    file_label="$(basename "${BASH_SOURCE[0]}")"
    timestamp="${RESET}[${BBLACK}$(date "+%Y-%M-%dT%T.%3N")${RESET}]${RESET}"
    if [[ "$level_label" != "" ]]; then
        if [[ "$FILELABEL" -ne 0 ]]; then output_string="$file_label: $default_output_string"; fi
        if [[ "$TIMESTAMP" -ne 0 ]]; then output_string="$file_label: $timestamp $level_label: $default_output_string"; fi
    else
        output_string="$default_output_string"
    fi

    # TODO: File Logging

    if [[ $lvl -gt 3 ]] && [[ $killerrors -ne 0 ]]; then
        printf "$file_label: Logging: 'killerrors' gaurd successful; logger registered an error, and has resulted in script termination.\n" 1>&/dev/null
        printf "$output_string${RESET}\n\n" 1>&2
        exit 1
    else
        printf "$file_label: Logging: 'killerrors' gaurd unsuccessful; outstring set to default.\n" 1>&/dev/null
        printf "$output_string\n" 1>&1
    fi

}

function setup_colors() {

    if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then

        RESET='\e[0m' # Reset

        # Regular Colors
        BLACK='\033[0;30m'  # Black            # Regular
        RED='\033[0;31m'    # Red              # Regular
        GREEN='\033[0;32m'  # Green            # Regular
        YELLOW='\033[0;33m' # Yellow           # Regular
        BLUE='\033[0;34m'   # Blue             # Regular
        PURPLE='\033[0;35m' # Purple           # Regular
        CYAN='\033[0;36m'   # Cyan             # Regular
        WHITE='\033[0;37m'  # White            # Regular

        # Bold
        BBLACK='\033[1;30m'  # Black            # Bold
        BRED='\033[1;31m'    # Red              # Bold
        BGREEN='\033[1;32m'  # Green            # Bold
        BYELLOW='\033[1;33m' # Yellow           # Bold
        BBLUE='\033[1;34m'   # Blue             # Bold
        BPURPLE='\033[1;35m' # Purple           # Bold
        BCYAN='\033[1;36m'   # Cyan             # Bold
        BWHITE='\033[1;37m'  # White            # Bold

        # Underline
        UBLACK='\033[4;30m'  # Black            # Underlined
        URED='\033[4;31m'    # Red              # Underlined
        UGREEN='\033[4;32m'  # Green            # Underlined
        UYELLOW='\033[4;33m' # Yellow           # Underlined
        UBLUE='\033[4;34m'   # Blue             # Underlined
        UPURPLE='\033[4;35m' # Purple           # Underlined
        UCYAN='\033[4;36m'   # Cyan             # Underlined
        UWHITE='\033[4;37m'  # White            # Underlined

        # Background
        ON_BLACK='\033[40m'  # Black            # Background
        ON_RED='\033[41m'    # Red              # Background
        ON_GREEN='\033[42m'  # Green            # Background
        ON_YELLOW='\033[43m' # Yellow           # Background
        ON_BLUE='\033[44m'   # Blue             # Background
        ON_PURPLE='\033[45m' # Purple           # Background
        ON_CYAN='\033[46m'   # Cyan             # Background
        ON_WHITE='\033[47m'  # White            # Background

        # High Intensity
        IBLACK='\033[0;90m'  # Black            # High Intensity
        IRED='\033[0;91m'    # Red              # High Intensity
        IGREEN='\033[0;92m'  # Green            # High Intensity
        IYELLOW='\033[0;93m' # Yellow           # High Intensity
        IBLUE='\033[0;94m'   # Blue             # High Intensity
        IPURPLE='\033[0;95m' # Purple           # High Intensity
        ICYAN='\033[0;96m'   # Cyan             # High Intensity
        IWHITE='\033[0;97m'  # White            # High Intensity

        # Bold High Intensity
        BIBLACK='\033[1;90m'  # Black            # Bold High Intensity
        BIRED='\033[1;91m'    # Red              # Bold High Intensity
        BIGREEN='\033[1;92m'  # Green            # Bold High Intensity
        BIYELLOW='\033[1;93m' # Yellow           # Bold High Intensity
        BIBLUE='\033[1;94m'   # Blue             # Bold High Intensity
        BIPURPLE='\033[1;95m' # Purple           # Bold High Intensity
        BICYAN='\033[1;96m'   # Cyan             # Bold High Intensity
        BIWHITE='\033[1;97m'  # White            # Bold High Intensity

        # High Intensity backgrounds
        ON_IBLACK='\033[0;100m'  # Black         # High Intensity backgrounds
        ON_IRED='\033[0;101m'    # Red           # High Intensity backgrounds
        ON_IGREEN='\033[0;102m'  # Green         # High Intensity backgrounds
        ON_IYELLOW='\033[0;103m' # Yellow        # High Intensity backgrounds
        ON_IBLUE='\033[0;104m'   # Blue          # High Intensity backgrounds
        ON_IPURPLE='\033[0;105m' # Purple        # High Intensity backgrounds
        ON_ICYAN='\033[0;106m'   # Cyan          # High Intensity backgrounds
        ON_IWHITE='\033[0;107m'  # White         # High Intensity backgrounds

    else

        # Set all the variables to an empty string
        # this will prevent errors from occuring when the variables are called.

        # Regular Colors
        BLACK=''
        RED=''
        GREEN=''
        YELLOW=''
        BLUE=''
        PURPLE=''
        CYAN=''
        WHITE=''

        # Bold
        BBLACK=''
        BRED=''
        BGREEN=''
        BYELLOW=''
        BBLUE=''
        BPURPLE=''
        BCYAN=''
        BWHITE=''
        # Underline
        UBLACK=''
        URED=''
        UGREEN=''
        UYELLOW=''
        UBLUE=''
        UPURPLE=''
        UCYAN=''
        UWHITE=''

        # Background
        ON_BLACK=''
        ON_RED=''
        ON_GREEN=''
        ON_YELLOW=''
        ON_BLUE=''
        ON_PURPLE=''
        ON_CYAN=''
        ON_WHITE=''

        # High Intensity
        IBLACK=''
        IRED=''
        IGREEN=''
        IYELLOW=''
        IBLUE=''
        IPURPLE=''
        ICYAN=''
        IWHITE=''

        # Bold High Intensity
        BIBLACK=''
        BIRED=''
        BIGREEN=''
        BIYELLOW=''
        BIBLUE=''
        BIPURPLE=''
        BICYAN=''
        BIWHITE=''

        # High Intensity backgrounds
        ON_IBLACK=''
        ON_IRED=''
        ON_IGREEN=''
        ON_IYELLOW=''
        ON_IBLUE=''
        ON_IPURPLE=''
        ON_ICYAN=''
        ON_IWHITE=''

    fi
}

function cleanup() {
    debug "Clearnup Trap: Starting cleanup process..."
    exit 1
}

determine_installation_varients() {
    for f in scripts/install_*.sh; do
        echo "Processing $f file.."
    done
}

# chmod +x script.sh

# Much like pythons: if __NAME_ == '__main__':
if ! [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    printf "$(basename "${BASH_SOURCE[0]}"): Script is being sourced, NOT calling _main() function.\n" 1>&/dev/null
else
    printf "$(basename "${BASH_SOURCE[0]}"): Script is a subshell, calling _main() function.\n" 1>&/dev/null
    _main "$@"
fi
