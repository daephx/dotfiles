#!/usr/bin/env bash
# The MIT License (MIT)
# Copyright © 2017-2023 Wenxuan Zhang <wenxuangm@gmail.com>
# Copyright © 2023-2024 daephx <daephxdev@gmail.com>
#
# This theme is a modified version of tmux-power theme
# NOTE: Some changes break default functionality.
# https://github.com/wfxr/tmux-power

# shellcheck disable=SC2034

# $1: option
# $2: default value
tmux_get() {
  local value
  value="$(tmux show -gqv "$1")"
  [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
  tmux set-option -gq "$1" "$2"
}

# Default colors
G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
BG="$G04"

# short for Theme-Colour
TC=$(tmux_get '@tmux_power_theme' 'default')
case $TC in
  'gold')
    TC='#ffb86c'
    ;;
  'redwine')
    TC='#b34a47'
    ;;
  'moon')
    TC='#00abab'
    ;;
  'forest')
    TC='#228b22'
    ;;
  'violet')
    TC='#9370db'
    ;;
  'coral')
    TC='#ff7f50'
    ;;
  'sky')
    TC='#87ceeb'
    ;;
  'default' | *?) # Useful when your term changes colour dynamically (e.g. pywal)
    TC='colour7'
    ;;
esac

# Options
border_color=$(tmux_get '@tmux_power_border_color' "$TC")
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
session_icon_fg="$(tmux_get '@tmux_power_session_icon_fg' "$G12")"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
user_icon_fg="$(tmux_get '@tmux_power_user_icon_fg' "$G12")"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
time_icon_fg="$(tmux_get '@tmux_power_time_icon_fg' "$G12")"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
date_icon_fg="$(tmux_get '@tmux_power_date_icon_fg' "$G12")"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')

# Enable transparent background color
TR=$(tmux_get '@tmux_power_transparent' 'false')
if [ "$TR" == 'true' ]; then
  BG="default"
fi

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-style "bg=$BG,fg=$FG"
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$BG]#[fg=$TC]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "G12"
tmux_set status-left-length 150
LS="#[bg=$BG,fg=$session_icon_fg] $session_icon #[fg=$TC,bg=$BG]#S "
if "$show_upload_speed"; then
  LS="$LS#[fg=$TC,bg=$BG]$right_arrow_icon#[fg=$TC,bg=$BG] $upload_speed_icon #{upload_speed} #[fg=$TC,bg=$BG]$right_arrow_icon"
else
  LS="$LS#[fg=$TC,bg=$BG]$right_arrow_icon"
fi
if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
  LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$BG"
tmux_set status-right-fg "$G12"
tmux_set status-right-length 150
user=$(whoami)
identity="#[fg=cyan,bg=$BG]$user#[fg=$G12,bg=$BG]@#[fg=blue,bg=$BG]#h#[fg=$TC,bg=$BG] #[fg=$user_icon_fg,bg=$BG,bold]$user_icon"
date="$date_format #[fg=$date_icon_fg,bg=$BG]$date_icon"
time="#[fg=$TC,bg=$BG]$time_format #[fg=$time_icon_fg,bg=$BG]$time_icon"
RS="$identity #[fg=$TC,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$BG] $time #[fg=$TC,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$BG] $date "
if "$show_download_speed"; then
  RS="#[fg=$TC,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$BG] $download_speed_icon #{download_speed} $RS"
fi
if "$show_web_reachable"; then
  RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
  RS=""
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$TC,bold] #I:#W#F "

# Window separator
tmux_set window-status-separator "#[bg=$BG,fg=$TC]$right_arrow_icon"

# Current window status
tmux_set window-status-current-status "bg=$BG fg=$TC"

# Pane border
tmux_set pane-border-style "bg=default,fg=$G06"

# Active pane border
tmux_set pane-active-border-style "bg=default,fg=$border_color"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"
