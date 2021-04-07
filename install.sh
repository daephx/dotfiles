#!/bin/bash
## $_PROGRAM $_VERSION - $_ORG [2021-01-01]
## Compatible with bash and dash/POSIX
##
## Usage: $PROG [OPTION...] [COMMAND]...
## Options:
##   -i, | --log-info     Set log level to info (default)
##   -q, | --log-quiet    Set log level to quiet
##   -l, | --log MESSAGE  Log a message
## Commands:
##   -h, | --help         Displays this help and exists
##   -v, | --version      Displays output version and exists
## Examples:
##   -r, | --repo         Repo url from GitHub https://github.com/<user>/dotfiles <repo_url>}
##   -p, | --path         Destination path to clone the repo "~/.dotfiles" <install_path>}

APP_VERSION="0.2.1"
APP_NAME="SymDot"
AUTHORNAME="daephx"
TRADEMARK=$(date +%Y)
LOGFORMAT="true" # timstamp on log output
LOGLEVEL="2"     # Default Log Level | 2:INFO

function usage() {
    echo -e "$(
        cat <<EOF
_______________________________________________________________________________

$APP_NAME v$APP_VERSION - $COMPANY [$TRADEMARK] : Compatible with bash and dash/POSIX

${WHITE}Usage: $(basename "${BASH_SOURCE[0]}") [-y] --repo <repo_url> --path <install_path>${BBLACK}
Options:
        --debug       ${WHITE}Print script version info${BBLACK}
        --verbose     ${WHITE}Print script debug info${BBLACK}
  -y, | --yes         ${WHITE}Automatically accept confirmation prompts${BBLACK}
Commands:
        --help        ${WHITE}Print the help message${BBLACK}
  -v, | --version     ${WHITE}Print script version info${BBLACK}
Examples:
  -r, | --repo <str>  ${WHITE}Repository URL to download from  https://github.com/<user>/dotfiles${BBLACK}
  -p, | --path <str>  ${WHITE}Destination path to clone the repo <install_path> "~/.dotfiles"${BBLACK}
\n_______________________________________________________________________________
EOF
    )" # this cannot not be on the EOF line
}

function cleanup() {
    debug "Clearnup Trap: Starting cleanup process..."
    trap - SIGINT SIGTERM ERR EXIT
    exit 1
}

function _main() {

    # set -e # stop execution if return not 0
    # set -Eeuo pipefail

    # default values of variables set from params
    NO_COLOR=0
    KILLERRORS=1 # enable terminating error messages
    setup_colors # assign color codes to variables

    argument_parser

    # if [ "$YES-" ] && echo "_main - YES!"

    # if [[ "$ENVIRONMENT" == "development" ]]; then LOGLEVEL="1"; fi
    debug "Environement Variable: ENVIRONMENT:development, Loading settings..."
    info "\n${YELLOW}This script is a work in progress, ${RED}use at your own risk!${RESET}"
    info "\n\tUNIX dotfile installation script!\n"
    info "  Path:\t\"$CLONEPATH\""
    info "  Repo:\t\"$REPOURL\"\n"
    printf "$(read -p "Press ENTER to continue, Ctrl+C to cancel...")\n"
    info "Starting installation process..."
    sleep 3

    check_config_providers $CLONEPATH # check data providers $1 || (.env)
    install_dependencies

    # confirm
    return

    if ! [[ -f ".gitconfig.local.symlink" ]]; then setup_gitconfig; fi
    if ! [[ -d "$CLONEPATH" ]]; then clone_dotfiles $CLONEPATH; fi
    debug "Change directory to installation path: '$CLONEPATH'"
    cd "$CLONEPATH"

    sleep 3
    info "Installation Process complete..."
    trap "cleanup" EXIT INT SIGINT SIGTERM ERR
}

function argument_parser() {
    # Ok, listen to me...
    # First we initalize the params variable, we do this so that it can be parsed.
    # we are expecting a string like this:

    #     "--debug --repo-url https://.../ --path /tmp/$APP_NAME"

    # With the paramaters in this format we will split them by the number of spaces.  The issue I'm
    # having is that some cli applications are diffrent with thier strings.  Part of this could be
    # my windows background but there are cases where things come in within quotations or
    # , where they are not as easily split.
    #
    #   "--repo=http://.../", "--path=/tmp/$APP_NAME"
    #
    # To remedy this, I wish to preprocess the strings, but finding the route has been difficult...
    # .*gasp*. Alright, so I think all the arguments are initialized at runtime and the parser is
    # already iterating the list; the list seems to change with scope but is it a list
    # "$1","$2", "$3", "$4" ...

    PARAMS=""
    while (("$#")); do
        split=$(split_equalsign_arguments $1)
        case "$1" in
        -h | --help)
            usage
            exit
            ;;
        -v | --version)
            info "$APP_NAME v$APP_VERSION"
            exit
            ;;
        --debug)
            LOGLEVEL=1
            debug "Argument Parser: '--debug' flag called: loglevel now equals 1 'LOGLEVEL=1'"
            # shift
            ;;
        --verbose)
            set -x
            debug "Argument Parser: '--verose' flag called: running command 'set -x'"
            shift
            ;;
        -y | --yes)
            YES=1
            debug "Argument Parser: '--yes' flag called: yes now equals 1 'YES=1'"
            shift
            ;;
        --repo=*)
            url_validator $1
            DOTFILE_REPO=$1
            debug "Argument Parser: '--repo' command called: 'DOTFILE_REPO=$1'"
            shift
            ;;
        --path=*)
            path_validator $1
            INSTALL_PATH=$1
            debug "Argument Parser: '--path' command called: 'INSTALL_PATH=$1'"
            shift
            ;;
        -?*) error "Argument Parser: Unknown option: $1" ;;
        *) # preserve positional arguments
            PARAMS="$PARAMS $1"
            debug "Argument Parser: Reattaching Paramas \"$PARAMS\" | \"{$1: $2: $3: $4}\""
            shift
            ;;
        esac
        shift
    done

    # set positional arguments in their proper place
    eval set -- "$PARAMS"
    info "$PARAMS"
    # error "he's dead jim..." # error terminates the script

    # word is the empty string, and the colon is omitted. Without the colon, the check is just for
    # unset, but not for null, so ${uno-} is equivalent to checking if uno is set '${parameter:-word}'

    args=("$@")
    [ -z "${DOTFILE_REPO-}" ] && error "${BRED}Missing required parameter:${RESET} REPO, Ex. <${YELLOW}https://githost.tld/<user>/dotfiles.git${RESET}>"
    [ -z "${INSTALL_PATH-}" ] && error "${BRED}Missing required parameter:${RESET} PATH, Ex. <${YELLOW}\$HOME/dotfiles/${RESET}>"
    [ ${#args[@]} -eq 0 ] && error "${BRED}Missing script arguments:${RESET} take a look at the usage $(usage)."
    # check required params and arguments
    return 0
}

function split_equalsign_arguments() {
    if [[ "$1" == "-.+=" ]] && [[ "$1" =~ "-.+=(.+)" ]]; then
        info "Attmpted split_argument on string $1\n\n\t${BASH_REMATCH[1]}"
    fi
}

function url_validator() {
    debug "Validators: url_validator verifying string '$1'"
    regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
    string="$1"
    if ! [[ $string =~ $regex ]]; then
        error "Validators: url_validator failed to verify: [${RED}FAIL${RESET}] '$1'"
    fi
    info "Validators: url_validator [${GREEN}GOOD${RESET}] '$1'"
    return 0
}

# function path_validator() {
#     if [[ "$1" =~ "-.+=(.+)" ]] && [[ $1 != "--path" ]]; then
#         INSTALL_PATH=${BASH_REMATCH[1]}
#     if
#     if ! [[ -f $1 ]] || ! [[ -f $2]]; then
#         error "Argument Parser: unable to parse string: '"$1"'"
#         exit 1
#     fi
# }

function setup_gitconfig() {
    if ! [[ -f git/gitconfig.local.symlink ]]; then
        debug "GitConfigInit: File Exists 'git/gitconfig.local.symlink'"
        git_credential="cache"
        if [[ "$(uname -s)" == "Darwin" ]]; then
            git_credential="osxkeychain"
            debug "GitConfigInit: 'uname -s' resolved to 'Dawrin', git_credential set to 'osxkeychain'"
        fi

        log " * What is your github author name?"
        read -e git_authorname
        log " * What is your github author email?"
        read -e git_authoremail

        sed \
            -e "s/AUTHORNAME/$git_authorname/g" \
            -e "s/AUTHOREMAIL/$git_authoremail/g" \
            -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" \
            git/gitconfig.local >git/gitconfig.local.symlink

        info "GitConfigInit: Successfully created gitconfig file"
    fi
}

function get_basic_credentials() {

    #
    # '-s' option prevents the user's typing from appearing in the terminal,
    #

    read -p "Enter your username: " username
    read -sp "Enter your password: " password
    echo
}

function install_dependencies() {
    info "Installing packages..."
    sleep 3
}

function clone_dotfiles() {

    # Inputs: PATH <STRING>
    #   clone_dotfiles only takes in a path destination
    #   the rest is supplised by global variables atm.

    if [[ -f "$1" ]]; then
        error "It appears that the provided path already exists.\n\n${RED}Conflict: ${BBLACK}'$1'"
    fi
    # info "Installing dotfiles..."
    git clone --recursive $REPOURL $CLONEPATH # Clone the repo
    cd "$CLONEPATH"                           # enter the .dotfile repo
}

function check_config_providers() {
    if [ "$1" == "" ] || [ $# -gt 1 ]; then             # check for script paramaters
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

# function parse_params() {

# }

function confirm() {
    if [[ "$yes" ]]; then log "YESSSS"; fi
}

# Logging functions
function error() { log "$1" 4; }
function warn() { log "$1" 3; }
function info() { log "$1" 2; }
function debug() { log "$1" 1; }
function msg() { log "$1" 0; }
function log() {

    case "$2" in
    4) loglvl="${BRED}ERR${RESET}" ;;   # Error
    3) loglvl="${YELLOW}WRN${RESET}" ;; # Warning
    2) loglvl="${WHITE}INF${RESET}" ;;  # Info
    1) loglvl="${CYAN}DBG${RESET}" ;;   # Debug
    0) ;;                               # No-label
    esac

    timestamp="${RESET}[${BBLACK}$(date "+%Y-%M-%dT%T.%3N")${RESET}]${BBLACK}"
    if ! [[ "LOGFORMAT" ]]; then timestamp=""; fi
    OUTSTRING+="$timestamp ${loglvl}: ${RESET}$1\n"
    if [[ "$2" == "4" ]] && [[ $KILLERRORS ]]; then
        debug "Logging: [[ '$2' == '4' ]] comparison successful; logger registered an error, this could result in script termination."
        printf "$OUTSTRING${RESET}\n" 1>&2
        exit 1
    elif (($2 >= $LOGLEVEL)) || (($2 == 0)); then
        debug "Logging: (($2 >= $LOGLEVEL)) || (($2 == 0)) comparison successful; outstring set to default."
        OUTSTRING="$1${RESET}\n"
        printf "$OUTSTRING" 1>&1
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

# Much like pythons: if __name__ == '__main__':
if ! [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    debug "Script is being sourced, no function calls today."
else
    debug "Script is a subshell, calling _main() function."
    _main "$@"
fi
