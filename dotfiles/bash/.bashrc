#    ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#    ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#    ██████╔╝███████║███████╗███████║██████╔╝██║
#    ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║
# ██╗██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
# ╚═╝╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_LOCAL_DIR="$HOME/.local"

if command -v oh-my-posh &>/dev/null; then
  eval "$(oh-my-posh --init --shell bash --config $XDG_CONFIG_HOME/poshthemes/slimy.omp.json)"
fi

# Python startup file, basic repl customization.
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc"
# Make python look in '~/.local/share/python/lib' for custom modules and packages
export PYTHONPATH="${PYTHONPATH}:${XDG_DATA_HOME:-$HOME/.local/share}/python/lib"

# Default editors
#export EDITOR="${TERM_PROGRAM:-vim}"
#export GIT_EDITOR=code
#export GUI_EDITOR=code

# History: Nice tutorial,
# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps

# Configure how the history is written
export HISTFILE="$XDG_CACHE_HOME/.bash_history"
export HISTSIZE=10000
export HISTFILESIZE=100000
export HISTIGNORE='ls:ll:la:lc:cd:gt:up:todo:exit:clear:hist:history'

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cmdhist
shopt -u lithist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Enable auto cd
# shopt -s autocd

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
# if [ -f "$HOME/.aliases" ]; then
#     source "$HOME/.aliases"
# fi

# if [ -f "$HOME/.bash_aliases" ]; then
#     source "$HOME/.bash_aliases"
# fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;

esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Personal Additions
export DISPLAY=:0.0
export LIBGL_ALWAYS_INDIRECT=1

# Personal Additions:
# export DISPLAY=:0.0
# export LIBGL_ALWAYS_INDIRECT=1

# Custom aliases
alias cls="clear"
# alias ls='ls -1 $@'

# vim config
# export MYVIMRC="${XDG_CONFIG_HOME:-$HOME/.config}/vim/init.vim"
# export VIMINIT="source $MYVIMRC"

# Python startup file, basic repl customization.
export PYTHONSTARTUP="${XDG_CONFIG_HOME:-$HOME/.config}/python/.pythonrc"

# Aliases
if [ -f "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi

# Functions
if [ -f "$HOME/.functions" ]; then
  source "$HOME/.functions"
fi

# bash config dir containing additional configs to be sourced
# Rewrite this if the configs are read from somewhere else
export BASHCONFD="$XDG_CONFIG_HOME/bash/.bashrc.d"

# Source the configurations in .bashrc.d directory
if [ -d "${BASHCONFD}" ]; then
  CONFS=[]
  CONFS=$(ls "${BASHCONFD}"/*.conf 2>/dev/null)
  if [ $? -eq 0 ]; then
    for CONF in ${CONFS[@]}; do
      source $CONF
    done
  fi
  unset CONFS
  unset CONF
fi
