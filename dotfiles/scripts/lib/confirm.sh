#!/usr/bin/env bash

function user_confirmation() {

    default_string=$1

    [[ -z ${default_string-} ]] && log error "User Confirmation: Default string was not supplied. '$default_string'"

    printf "$1\n\n"

    echo -n "Do you wish to continue? [y/n]: "
    while true; do
        read -e yn
        case $yn in
        [Yy]*) return 0 ;;
        [Nn]*) exit 1 ;;
        *) echo -ne "\rPlease answer yes or no. [y/n]: " ;;
        esac
    done
}
