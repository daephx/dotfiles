# Prompt: Initialize user prompt for POSIX-compliant shells.
# This script sets up shell prompts with colors and Git information,
# and initializes custom prompt providers if available.
# shellcheck shell=sh

# Check for uncommitted changes in Git repository.
parse_git_dirty() {
  [ "$(git status --porcelain 2> /dev/null)" ] && echo "*"
}

# Retrieve the current Git branch and append dirty status.
parse_git_branch() {
  git branch --no-color 2> /dev/null \
    | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# Initialize the prompt for Bash with colors and Git information.
__init_prompt_bash() {
  RESET=$(tput sgr0)
  YELLOW=$(tput setaf 3)
  BLUE=$(tput setaf 4)
  CYAN=$(tput setaf 6)
  GREY=$(tput setaf 244)
  user="\[$CYAN\]$USER"
  git="\[$YELLOW\]$(parse_git_branch)"
  PS1="\[$GREY\]┌ $user\[$GREY\]:\[$BLUE\]\w $git\n\[$GREY\]└$ \[$RESET\]"
  PS2="\[$GREY\] > \[$RESET\]"
}

# Initialize the prompt for Zsh with colors and Git information.
__init_prompt_zsh() {
  NEWLINE=$'\n'
  user="%F{cyan}${USER}"
  git="%F{yellow}$(parse_git_branch)"
  PS1="%F{244}┌ %F{244}$user%F{244}:%F{blue}%~ $git${NEWLINE}%F{244}└%F{244}$ %F{reset}"
  PS2="%F{244} > %F{reset}"
}

# Initialize Oh-My-Posh prompt with custom theme.
__init_prompt_omp() {
  command -v oh-my-posh > /dev/null || return
  shell="$1"
  theme_file="skellum.omp.toml"
  theme_dir="$XDG_CONFIG_HOME/oh-my-posh/themes"
  eval "$(oh-my-posh init "$shell" --config "$theme_dir/$theme_file")"
}

# Initialize Starship prompt with custom theme.
__init_prompt_starship() {
  command -v starship > /dev/null || return
  shell="$1"
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
  eval "$(starship init "$shell")"
}

# Determine the type of shell in use.
[ -n "$BASH_VERSION" ] && shell="bash"
[ -n "$ZSH_VERSION" ] && shell="zsh"

# Initialize custom prompt providers if available.
__init_prompt_omp "$shell" && return
__init_prompt_starship "$shell" && return

# Set basic backup prompts for Bash and Zsh if custom providers are not used.
[ "$shell" = "bash" ] && __init_prompt_bash
[ "$shell" = "zsh" ] && __init_prompt_zsh

# Clean up temporary variables.
unset shell
