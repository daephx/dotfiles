#    ███████╗███████╗██╗  ██╗██████╗  ██████╗
#    ╚══███╔╝██╔════╝██║  ██║██╔══██╗██╔════╝
#      ███╔╝ ███████╗███████║██████╔╝██║
#     ███╔╝  ╚════██║██╔══██║██╔══██╗██║
# ██╗███████╗███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# profile loading timer init
integer t0=$(($(date +%s%N)/1000000))

# Enabled prompt theme
if command -v oh-my-posh &>/dev/null; then
  # precmd() { print "" } # add extra newline
  eval "$(oh-my-posh --init --shell zsh --config $XDG_CONFIG_HOME/poshthemes/slimy.omp.json)"
else
# Enable oh-my-zsh / Powerlevel10k
# Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  source "$XDG_CONFIG_HOME/zsh/oh-my-zsh.zsh"
fi

# Default editors
# export EDITOR="${TERM_PROGRAM:-vim}"
# export GIT_EDITOR=code
# export GUI_EDITOR=code

# History: Nice tutorial,
# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps

# Configure how the history is written
export HISTFILE="$XDG_CACHE_HOME/.zsh_history"
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:ll:la:lc:cd:gt:up:todo:exit:clear:hist:history'

unsetopt beep
bindkey -e

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Source the configurations in .zshrc.d directory
if [ -d "${ZSHCONFD}" ]; then
    CONFS=[]
    CONFS=$(ls "${ZSHCONFD}"/*.zsh 2> /dev/null)
    if [ $? -eq 0 ]; then
        for CONF in ${CONFS[@]}
        do
            source $CONF
        done
    fi
    unset CONFS
    unset CONF
fi

# load after zshrc.d files to make sure that ~/.local/bin is the first in $PATH
export PATH="${HOME}/.local/bin:${PATH}"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions

# Functions definitions.
if [ -f "$HOME/.functions" ]; then
  source "$HOME/.functions"
fi

# Alias definitions.
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

if [ -f "$HOME/.zsh_aliases" ]; then
  source "$HOME/.zsh_aliases"
fi

# Output startup time
function {
    local -i t1 startup
    t1=$(($(date +%s%N)/1000000))
    startup=$(( t1 - t0 ))
    [[ $startup -gt 1 ]] && print "Loading shell profile took: ${startup}ms"
}
unset t0
