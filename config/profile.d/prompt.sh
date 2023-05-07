# ~/.prompt: initialize basic prompt for posix shells
# shellcheck shell=sh
# vim: ft=sh:

parse_git_dirty() {
  [ "$(git status --porcelain 2> /dev/null)" ] && echo "*"
}

parse_git_branch() {
  git branch --no-color 2> /dev/null \
    | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

bash_prompt() {
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

zsh_prompt() {
  # shellcheck disable=3003
  NEWLINE=$'\n'
  user="%F{cyan}${USER}"
  git="%F{yellow}$(parse_git_branch)"
  PS1="%F{244}┌ %F{244}$user%F{244}:%F{blue}%~ $git${NEWLINE}%F{244}└%F{244}$ %F{reset}"
  PS2="%F{244} > %F{reset}"
}

oh_my_posh() {
  shell="$1"
  theme_name="skellum"
  theme_file="$theme_name.omp.json"
  theme_path="$XDG_CONFIG_HOME/poshthemes/$theme_file"
  eval "$(oh-my-posh init "$shell" --config "$theme_path")"
}

# shellcheck disable=2317
# fall-through to default prompt, prefer special case
initalize_prompt() {
  [ -n "$BASH_VERSION" ] && shell="bash"
  [ -n "$ZSH_VERSION" ] && shell="zsh"
  command -v oh-my-posh > /dev/null && oh_my_posh "$shell" && return
  [ "$shell" = "bash" ] && bash_prompt
  [ "$shell" = "zsh" ] && zsh_prompt
}

# Finally, initalize prompt
initalize_prompt