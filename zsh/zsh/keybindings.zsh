#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

# these read the terminfo and allow the keybindings to work across terminals
# but they may not work in all of them, especially control options
typeset -A KEYS
KEYS[UP]=${terminfo[kcuu1]}
KEYS[DOWN]=${terminfo[kcud1]}
KEYS[LEFT]=${terminfo[kcub1]}
KEYS[RIGHT]=${terminfo[kcuf1]}
KEYS[C_UP]=${terminfo[kUP5]}
KEYS[C_RIGHT]=${terminfo[kDN5]}
KEYS[C_LEFT]=${terminfo[kLFT5]}
KEYS[C_RIGHT]=${terminfo[kRIT5]}

KEYS[TAB]=${terminfo[ht]}

KEYS[BACKSPACE]=${terminfo[kbs]}
KEYS[C_BACKSPACE]=${terminfo[cub1]} # !!

KEYS[DELETE]=${terminfo[kdch1]}
KEYS[C_DELETE]=${terminfo[kDC5]} # !!

# ctr + left / right arrow keys
bindkey "${KEYS[C_LEFT]}" backward-word
bindkey "${KEYS[C_RIGHT]}" forward-word

# make tab on empty buffer autocomplete like cd
_first-tab() {
    emulate -LR zsh

    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi

    zle redisplay
}
zle -N _first-tab
bindkey "${KEYS[TAB]}" _first-tab

# deletes first word to allow quick switch of command
_quick-cmd-edit() {
    zle beginning-of-line
    zle delete-word
    zle redisplay
}
zle -N _quick-cmd-edit
bindkey '^X' _quick-cmd-edit

# keybinding for isearch
bindkey '^R' history-incremental-search-backward

# better search mode
bindkey -M isearch "${KEYS[UP]}" history-incremental-search-backward
bindkey -M isearch "${KEYS[DOWN]}" history-incremental-search-forward
bindkey -M isearch '^[' send-break
bindkey -M isearch "${KEYS[BACKSPACE]}" backward-delete-word

# delete and ctrl delete
bindkey "${KEYS[DELETE]}" delete-char
bindkey "${KEYS[C_DELETE]}" delete-word

# ctrl backspace
bindkey "${KEYS[C_BACKSPACE]}" backward-delete-word

# push current buffer into stack which pops back up after execution of anything
bindkey '^Q' push-input

# edit the command line command in the editor (does not execute automatically)
autoload -z edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line

_mux-select() {
    emulate -LR zsh

    # only run on empty buffer
    if [[ $#BUFFER == 0 ]]; then
        BUFFER="mux-select"
        zle accept-line
        zle redisplay
    fi
}
zle -N _mux-select
bindkey '^S' _mux-select

