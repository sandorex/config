#!/bin/bash
# the beginning and the end

function trysource() {
    if [[ -f "$1" ]]; then
        \. "$1"
    fi
}

# minimal prompt
export PS1="\[$(tput setaf 2)\]%\[$(tput sgr0)\] "

# load aliases
source ~/.config/bash/aliases.bash

export PATH=$PATH:"$HOME"/.bin

trysource "~/.config/bash/host/$(hostname).bash"

# i do not need it anymore
unset trysource

