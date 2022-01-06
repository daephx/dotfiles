#!/usr/bin/env bash

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
