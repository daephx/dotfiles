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

  # Path to your oh-my-zsh installation.
  export ZSH="$ZDOTDIR/oh-my-zsh"
  export _Z_DIRS="$XDG_CACHE_HOME/.z"

  # Would you like to use another custom folder than $ZSH/custom?
  ZSH_CUSTOM="$ZDOTDIR/custom"
  source $ZSH/oh-my-zsh.sh

  # To customize prompt, run `p10k configure` or edit $ZDOTDIR/p10k.zsh.
  # [[ ! -f "$ZDOTDIR/p10k.zsh" ]] || source "$ZDOTDIR/p10k.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE="$XDG_CACHE_HOME/.histfile"
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

plugins=(
  git
  z
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
)

# Compilation flags
# export ARCHFLAGS="-arch x86_64"



# User configuration

# source contents from ~/.zshrc.d/*.zsh
for file in "${ZDOTDIR:-$HOME/.config}/.zshrc.d/*.zsh"; do
  [[ -f "${file}" ]] && source "${file}"
done



# load after ~/.zshrc.d files to make sure that ~/.local/bin is the first in $PATH
export PATH="${HOME}/.local/bin:${PATH}"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR="${TERM_PROGRAM:-vim}"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

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
