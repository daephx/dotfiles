#!/usr/bin/env zsh

# windows-like inline editing using Windows Terminal + wsl
# Credit: https://gist.github.com/jamietre/65869c073119bb68f283e635cf6463b1

r-delregion() {
  if ((REGION_ACTIVE)) then
    zle kill-region
  else
    local widget_name=$1
    shift
    zle $widget_name -- $@
  fi
}

r-deselect() {
  ((REGION_ACTIVE = 0))
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

r-select() {
  ((REGION_ACTIVE)) || zle set-mark-command
  local widget_name=$1
  shift
  zle $widget_name -- $@
}

# r-copy-to-xclip() {
#   [[ "$REGION_ACTIVE" -ne 0 ]] && zle copy-region-as-kill
#   printf $CUTBUFFER | clip.exe
# }


for key     kcap   seq        mode   widget (
    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history

    send    kEND   $'\E[1;2F' select   end-of-line
    send2   x      $'\E[4;2~' select   end-of-line

    shome   kHOM   $'\E[1;2H' select   beginning-of-line
    shome2  x      $'\E[1;2~' select   beginning-of-line

    left    kcub1  $'\EOD'    deselect backward-char
    right   kcuf1  $'\EOC'    deselect forward-char

    end     kend   $'\EOF'    deselect end-of-line
    end2    x      $'\E4~'    deselect end-of-line

    home    khome  $'\EOH'    deselect beginning-of-line
    home2   x      $'\E1~'    deselect beginning-of-line

    csleft  x      $'\E[1;6D' select   backward-word
    csright x      $'\E[1;6C' select   forward-word
    csend   x      $'\E[1;6F' select   end-of-line
    cshome  x      $'\E[1;6H' select   beginning-of-line

    cleft   x      $'\E[1;5D' deselect backward-word
    cright  x      $'\E[1;5C' deselect forward-word

    del     kdch1   $'\E[3~'  delregion delete-char
    bs      x       $'^?'     delregion backward-delete-char
  ) {
  eval "key-$key() {
    r-$mode $widget \$@
  }"
  zle -N key-$key
  bindkey ${terminfo[$kcap]-$seq} key-$key
}

# bind CTRL+C to copy to the clipboard; we don't want to use the native Windows Terminal
# "copy" because it won't work for selections done via zsh on the command line. You can still
# use Windows Terminal functionality for mouse-selecting blocks of text, etc. However
# we still use native pasting from Windows Terminal so it works consistently everywhere

# zle -N r-copy-to-xclip
# bindkey "^C" r-copy-to-xclip

# this unbinds ^C before a command is executed (binds to ^Y instead, change to suit your taste),
# so it will cause an interrupt as  expected unless a command line is being edited (when it will
# act as "copy").

# preexec() {
#   stty intr \^C
# }

# precmd() {
#   stty intr \^Y
# }