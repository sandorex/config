#!/usr/bin/env zsh
#
# keybindings.zsh - keybindings for zsh

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

# TODO add ALT + , and ALT + .

# ctr + left / right arrow keys
bindkey "${KEYS[C_LEFT]}" backward-word
bindkey "${KEYS[C_RIGHT]}" forward-word

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
# regular edit-command-line does not refresh so can mess up the screen
_edit-command-fixed() {
    emulate -LR zsh
    zle edit-command-line
    zle redisplay
}
autoload -z edit-command-line
zle -N _edit-command-fixed
bindkey '^E' _edit-command-fixed

# makes ctrl z run fg
_job-switch() {
    emulate -LR zsh

    fg
    zle redisplay
}
zle -N _job-switch
bindkey '^Z' _job-switch

_go_back() {
    # save buffer
    zle push-input

    # change command
    BUFFER="cd .."

    # run command and automatically the buffer is restored
    zle accept-line
    zle redisplay
}
zle -N _go_back
bindkey '^[,' _go_back

_go_forward() {
    # save buffer
    zle push-input

    # change command
    BUFFER="cd -"

    # run command and automatically the buffer is restored
    zle accept-line
    zle redisplay
}
zle -N _go_forward
bindkey '^[.' _go_forward

