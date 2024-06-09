# .prompt: Initialize user prompt for posix shells.

parse_git_dirty() {
  [ "$(git status --porcelain 2> /dev/null)" ] && echo "*"
}

parse_git_branch() {
  git branch --no-color 2> /dev/null \
    | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}
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

__init_prompt_zsh() {
  NEWLINE=$'\n'
  user="%F{cyan}${USER}"
  git="%F{yellow}$(parse_git_branch)"
  PS1="%F{244}┌ %F{244}$user%F{244}:%F{blue}%~ $git${NEWLINE}%F{244}└%F{244}$ %F{reset}"
  PS2="%F{244} > %F{reset}"
}

__init_prompt_omp() {
  command -v oh-my-posh > /dev/null || return
  shell="$1"
  theme_file="skellum.omp.toml"
  theme_dir="$XDG_CONFIG_HOME/oh-my-posh/themes"
  eval "$(oh-my-posh init "$shell" --config "$theme_dir/$theme_file")"
}

__init_prompt_starship() {
  command -v starship > /dev/null || return
  shell="$1"
  export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
  eval "$(starship init "$shell")"
}

# Determine prompt shell
[ -n "$BASH_VERSION" ] && shell="bash"
[ -n "$ZSH_VERSION" ] && shell="zsh"

# Custom prompt providers, return if function completes without error
__init_prompt_omp "$shell" && return
__init_prompt_starship "$shell" && return

# Basic backup prompts for each shell
[ "$shell" = "bash" ] && __init_prompt_bash
[ "$shell" = "zsh" ] && __init_prompt_zsh

# Cleanup temp variables
unset shell
