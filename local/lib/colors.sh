#!/usr/bin/env bash

function __initalize() {

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

    RESET='' # Reset

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

# if this script is sourced, colors variables will automatically be set
# Much like pythons: if __name__ == '__main__':
if ! [ "${BASH_SOURCE[0]}" == "${0}" ]; then
  __initalize "$@"
fi
