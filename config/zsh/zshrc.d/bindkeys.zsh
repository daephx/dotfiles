#!/usr/bin/env zsh

# Credit: https://stackoverflow.com/a/68987551

# user-specific terminal emulator keybindings
CTRL_U='^U'
CMD_A=$'\eå'
CMD_C=$'\eç'
CMD_V=$'\e√'
CMD_X=$'\e≈'
CMD_Z=$'\eΩ'
CMD_SHIFT_Z=$'\e¸'
CMD_LEFT=$'\x01' # ^A
CMD_RIGHT=$'\x05' # ^B
CMD_SHIFT_LEFT=$'\ea'
CMD_SHIFT_RIGHT=$'\ee'
CTRL_SHIFT_A=$'\ea'
CTRL_SHIFT_E=$'\ee'

#        shell-key     widget
bindkey  $CTRL_U       backward-kill-line
bindkey  $CMD_Z        undo
bindkey  $CMD_SHIFT_Z  redo

# `pbpaste` and `pbcopy` are MacOS specific
# clipboard handler commands, for Linux I think
# it's `xclip`
if [[ `uname -s` = Darwin ]];
then
    # copy entire terminal line to clipboard
    # function widget::copy-line() {
    #     printf "%s" "$BUFFER" | pbcopy
    # }
    # zle -N widget::copy-line
    # bindkey $CMD_A widget::copy-line

    # copy selected terminal text to clipboard
    function widget::copy-selection {
        if ((REGION_ACTIVE)); then
            zle copy-region-as-kill
            printf "%s" $CUTBUFFER | pbcopy
        fi
    }
    zle -N widget::copy-selection
    bindkey $CMD_C widget::copy-selection

    # cut selected terminal text to clipboard
    function widget::cut-selection() {
        if ((REGION_ACTIVE)) then
            zle kill-region
            printf "%s" $CUTBUFFER | pbcopy
        fi
    }
    zle -N widget::cut-selection
    bindkey $CMD_X widget::cut-selection

    # paste clipboard contents
    function widget::paste() {
        ((REGION_ACTIVE)) && zle kill-region
        RBUFFER="$(pbpaste)${RBUFFER}"
        CURSOR=$(( CURSOR + $(echo -n $(pbpaste) | wc -c | bc) ))
    }
    zle -N widget::paste
    bindkey $CMD_V widget::paste
fi

function widget::select-all() {
    local buflen=$(printf "$BUFFER" | wc -m | bc)
    CURSOR=0
    zle set-mark-command
    while [[ $CURSOR < $buflen ]]; do
        zle end-of-line
        zle forward-char
    done
}
zle -N widget::select-all
# bindkey $KEY_CMD_A widget::select-all

function widget::util-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-unselect() {
    REGION_ACTIVE=0
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

function widget::util-delselect() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

function widget::util-insertchar() {
    ((REGION_ACTIVE)) && zle kill-region
    RBUFFER="${1}${RBUFFER}"
    zle forward-char
}

for keyname           kcap   seq               mode        widget (
    left              kcub1  $'\eOD'           unselect    backward-char
    right             kcuf1  $'\eOC'           unselect    forward-char
    shift-left        kLFT   $'\e[1;2D'        select      backward-char
    shift-right       kRIT   $'\e[1;2C'        select      forward-char
    shift-up          kri    $'\e[1;2A'        select      up-line-or-history
    shift-down        kind   $'\e[1;2B'        select      down-line-or-history

    alt-left          x      $'\e[1;9D'        unselect    backward-word
    alt-right         x      $'\e[1;9C'        unselect    forward-word
    alt-shift-left    x      $'\e[1;10D'       select      backward-word
    alt-shift-right   x      $'\e[1;10C'       select      forward-word

    cmd-left          x      $CMD_LEFT         unselect    backward-word
    cmd-right         x      $CMD_RIGHT        unselect    forward-word
    cmd-shift-left    x      $CMD_SHIFT_LEFT   select      backward-word
    cmd-shift-right   x      $CMD_SHIFT_RIGHT  select      forward-word

    ctrl-a            x      '^A'              unselect    beginning-of-line
    ctrl-e            x      '^E'              unselect    end-of-line
    ctrl-shift-a      x      $CTRL_SHIFT_A     select      beginning-of-line
    ctrl-shift-e      x      $CTRL_SHIFT_E     select      end-of-line
    ctrl-shift-left   x      $'\e[1;6D'        select      backward-word
    ctrl-shift-right  x      $'\e[1;6C'        select      forward-word

    esc               x      $'\e'             unselect    reset-prompt
    del               x      $'^D'             delselect   delete-char
    backspace         x      $'^?'             delselect   backward-delete-char

    a                 x       'a'              insertchar  'a'
    b                 x       'b'              insertchar  'b'
    c                 x       'c'              insertchar  'c'
    d                 x       'd'              insertchar  'd'
    e                 x       'e'              insertchar  'e'
    f                 x       'f'              insertchar  'f'
    g                 x       'g'              insertchar  'g'
    h                 x       'h'              insertchar  'h'
    i                 x       'i'              insertchar  'i'
    j                 x       'j'              insertchar  'j'
    k                 x       'k'              insertchar  'k'
    l                 x       'l'              insertchar  'l'
    m                 x       'm'              insertchar  'm'
    n                 x       'n'              insertchar  'n'
    o                 x       'o'              insertchar  'o'
    p                 x       'p'              insertchar  'p'
    q                 x       'q'              insertchar  'q'
    r                 x       'r'              insertchar  'r'
    s                 x       's'              insertchar  's'
    t                 x       't'              insertchar  't'
    u                 x       'u'              insertchar  'u'
    v                 x       'v'              insertchar  'v'
    w                 x       'w'              insertchar  'w'
    x                 x       'x'              insertchar  'x'
    y                 x       'y'              insertchar  'y'
    z                 x       'z'              insertchar  'z'
    A                 x       'A'              insertchar  'A'
    B                 x       'B'              insertchar  'B'
    C                 x       'C'              insertchar  'C'
    D                 x       'D'              insertchar  'D'
    E                 x       'E'              insertchar  'E'
    F                 x       'F'              insertchar  'F'
    G                 x       'G'              insertchar  'G'
    H                 x       'H'              insertchar  'H'
    I                 x       'I'              insertchar  'I'
    J                 x       'J'              insertchar  'J'
    K                 x       'K'              insertchar  'K'
    L                 x       'L'              insertchar  'L'
    M                 x       'M'              insertchar  'M'
    N                 x       'N'              insertchar  'N'
    O                 x       'O'              insertchar  'O'
    P                 x       'P'              insertchar  'P'
    Q                 x       'Q'              insertchar  'Q'
    R                 x       'R'              insertchar  'R'
    S                 x       'S'              insertchar  'S'
    T                 x       'T'              insertchar  'T'
    U                 x       'U'              insertchar  'U'
    V                 x       'V'              insertchar  'V'
    W                 x       'W'              insertchar  'W'
    X                 x       'X'              insertchar  'X'
    Y                 x       'Y'              insertchar  'Y'
    Z                 x       'Z'              insertchar  'Z'
    0                 x       '0'              insertchar  '0'
    1                 x       '1'              insertchar  '1'
    2                 x       '2'              insertchar  '2'
    3                 x       '3'              insertchar  '3'
    4                 x       '4'              insertchar  '4'
    5                 x       '5'              insertchar  '5'
    6                 x       '6'              insertchar  '6'
    7                 x       '7'              insertchar  '7'
    8                 x       '8'              insertchar  '8'
    9                 x       '9'              insertchar  '9'

    exclamation-mark      x  '!'               insertchar  '!'
    hash-sign             x  '\#'              insertchar  '\#'
    dollar-sign           x  '$'               insertchar  '$'
    percent-sign          x  '%'               insertchar  '%'
    ampersand-sign        x  '\&'              insertchar  '\&'
    star                  x  '\*'              insertchar  '\*'
    plus                  x  '+'               insertchar  '+'
    comma                 x  ','               insertchar  ','
    dot                   x  '.'               insertchar  '.'
    forwardslash          x  '\\'              insertchar  '\\'
    backslash             x  '/'               insertchar  '/'
    colon                 x  ':'               insertchar  ':'
    semi-colon            x  '\;'              insertchar  '\;'
    left-angle-bracket    x  '\<'              insertchar  '\<'
    right-angle-bracket   x  '\>'              insertchar  '\>'
    equal-sign            x  '='               insertchar  '='
    question-mark         x  '\?'              insertchar  '\?'
    left-square-bracket   x  '['               insertchar  '['
    right-square-bracket  x  ']'               insertchar  ']'
    hat-sign              x  '^'               insertchar  '^'
    underscore            x  '_'               insertchar  '_'
    left-brace            x  '{'               insertchar  '{'
    right-brace           x  '\}'              insertchar  '\}'
    left-parenthesis      x  '\('              insertchar  '\('
    right-parenthesis     x  '\)'              insertchar  '\)'
    pipe                  x  '\|'              insertchar  '\|'
    tilde                 x  '\~'              insertchar  '\~'
    at-sign               x  '@'               insertchar  '@'
    dash                  x  '\-'              insertchar  '\-'
    double-quote          x  '\"'              insertchar  '\"'
    single-quote          x  "\'"              insertchar  "\'"
    backtick              x  '\`'              insertchar  '\`'
    whitespace            x  '\ '              insertchar  '\ '
) {
    eval "
        function widget::key-$keyname() {
            widget::util-$mode $widget \$@
        }
    "
    zle -N widget::key-$keyname
    bindkey ${terminfo[$kcap]:-$seq} widget::key-$keyname
}
