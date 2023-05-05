#!/usr/bin/env zsh
#
# quick-sudo.zsh - plugin for quick prefixing sudo for command
#
# inspired by ohmyzsh sudo

quick-sudo() {
    emulate -LR zsh

    if [[ ! "$BUFFER" =~ ^[:blank:]*sudo ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( $CURSOR + 5 ))
    fi

    zle redisplay
}


quick-sudo-e() {
    emulate -LR zsh

    if [[ ! "$BUFFER" =~ ^[:blank:]*sudo ]]; then
        BUFFER="sudo -e $BUFFER"
        CURSOR=$(( $CURSOR + 8 ))
    fi

    zle redisplay
}

zle -N quick-sudo
bindkey '\e\e' quick-sudo

# NOTE: i changed shift escape to '^[[[' (raw \x1b[[)
zle -N quick-sudo-e
bindkey '^[[[^[[[' quick-sudo-e
