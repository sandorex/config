#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

# ctr + left / right arrow keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

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
bindkey '^I' _first-tab

# keybinding for isearch
bindkey '^R' history-incremental-search-backward

# better search mode
bindkey -M isearch '^[[A' history-incremental-search-backward
bindkey -M isearch '^[[B' history-incremental-search-forward
bindkey -M isearch '^[' send-break
bindkey -M isearch '^?' backward-delete-word

# delete and ctrl delete
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' delete-word

# ctrl backspace
bindkey '^H' backward-delete-word

# push current buffer into stack which pops back up after execution of anything
bindkey '^Q' push-input

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

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

