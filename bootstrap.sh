#!/usr/bin/env bash
# Reference: https://github.com/ActionScripted/dotfiles/blob/master/bootstrap.sh
# ---
# dotfiles boostrap
#
# DON'T FREAK! It backs everything up to:
#   ~/.dotfiles.backups
#
# ...unless you've tampered with things

function _main() {

    set -e # stop execution if return not 0
    LOGLEVEL=1
    SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd) # full path to script parent
    CURRENTFILE=$(basename "${BASH_SOURCE[0]}")            # the file that is currently being executed
    BACKUPDIR="$SCRIPT_DIR/backups"                        # location for your home files to be kept safe
    cd $SCRIPT_DIR                                         # Making sure you are in the right path
    source "$SCRIPT_DIR/install.sh"                        # asking a friend for help
    setup_colors                                           # assign color codes to variables

    debug "Bootstrap: Sourced script '$SCRIPT_DIR/install.sh'"

    if [[ $SUDO_USER ]]; then error "If we need it then we'll ask, Try again without 'sudo'."; fi
    if ! [[ ".git" ]]; then error "Bootstrap: could not locate git repository."; fi # (.env) variable injection
    if ! [[ $(git config --get remote.origin.url) == "https://github.com/daephx/dotfiles" ]]; then
        error "Bootstrap: wrong repository brother, you're using my setup now."
    fi
    # if [[ -f ".env" ]]; then export $(cat .env | xargs); fi                         # (.env) variable injection
    # out $DOTFILES_BACKUP                                                            # TEST

    # git pull origin main # Update the repository
    # ?: Potentially determine git error
    # ?. such as, 'fatal: refusing to merge unrelated histories'

    confirm "User Confirmation required:

  This is going to move all dotfiles (.*) from within your \$HOME directory;
  your files will be backed up into the specified backup location,

  Backup Directory: $BACKUPDIR"

    debug "Bootstrap: change into \$HOME directory: '$HOME'"
    cd $HOME # Go back home to start bootstrap

    if [[ ! -e $BACKUPDIR ]]; then
        debug "Bootstrap: Creating backup directory '$BACKUPDIR'"
        mkdir -p $BACKUPDIR
    fi

    dotfiles=get_home_dotfiles
    backup_dotfile $dotfiles
    return

    if [[ $dotfiles ]]; then
        info "Symlinking dotfiles..."

        for dotfile in $dotfiles; do
            if [[ $dotfile == .* ]]; then
                debug "Bootstrap: dotfile loop: '$dotfile'"
            fi
            debug "$dotfile"
            # backup_dotfile $dotfile
            # symlink_dotfile $dotfile
        done

        info "All set! Any existing files were moved to $BACKUPDIR"

    else
        info "You don't have anything in '$DOTFILEDIR', bro-tato"
    fi

}

function doIt() {
    declare -a exclude=(
        ".git/"
        ".DS_Store"
        ".osx"
        ".env"
        ".env.example"
        ".gitignore"
        "scripts/"
        "bootstrap.sh"
        "install.sh"
        "README.md"
        "TODO.md"
        "LICENSE*"
    ) # general exclusions

    cmd="rsync"
    for val in "${exclude[@]}"; do
        cmd+=" --exclude '${val}'"
    done
    cmd+=" -avh --no-perms . ~"

    out $cmd

    # rsync \
    #     --exclude ".git/" \
    #     --exclude ".DS_Store" \
    #     --exclude ".osx" \
    #     --exclude "bootstrap.sh" \
    #     --exclude "README.md" \
    #     --exclude "LICENSE-MIT.txt" \
    #     -avh --no-perms . ~
    # source ~/.bash_profile
}

function backup_dotfile() {
    if [[ -e "$HOME/$1" ]]; then

        # Do we already have any backups? How many?
        # This needs some work. Doesn't handle things like
        # $BACKUPDIR/.vim* and $BACKUPDIR/.vimrc* well
        dotfile_count=$(find $BACKUPDIR/$1* -maxdepth 0 2>/dev/null | wc -l | sed 's/ //g')

        if [[ $dotfile_count -ne '0' ]]; then
            error "ooohh no"
            # mv $HOME/$1 $BACKUPDIR/$1.$dotfile_count
        else
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            $BACKUPDIR+="$timestamp"

            return

            if [[ -d "$BACKUPDIR" ]]; then
                error -e "\e[0mDirectory \e[1m$BACKUPDIR\e[0m already exists.\e[0m"
            fi
            mkdir $BACKUPDIR/ 1>/dev/null
            mv $HOME/$1 $BACKUPDIR/$1
        fi
    fi
}

function symlink_dotfile() {
    ln -s $DOTFILEDIR/$1 $HOME/$1
}

function get_home_dotfiles() {
    declare -a exclude=(
        ".env.example"
        ".env"
        ".git"
        ".gitignore"
        "bootstrap"
        "install"
        "backup"
        "dot"
        "scripts"
    )
    cmd="ls -1 -A $DOTFILEDIR | grep -Fv"
    for val in "${exclude[@]}"; do
        cmd+=" -e '${val}'"
    done
    cmd+=" 2>/dev/null"

    eval $cmd
}

function special_cases() {
    include=(
        "~/.vscode-server/data/Machine/settings.json"
        "~/.docker/config.json"
    )
}

# Much like pythons: if __NAME_ == '__main__':
if ! [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    printf "$(basename "${BASH_SOURCE[0]}"): Script is being sourced, NOT calling _main() function.\n" 1>&/dev/null
else
    printf "$(basename "${BASH_SOURCE[0]}"): Script is a subshell, calling _main() function.\n" 1>&/dev/null
    _main "$@"
fi
