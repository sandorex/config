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
\. ~/.config/bash/aliases.bash

# load linux terminal theming
trysource ~/.shell/bare-terminal-theming.sh

export PATH=$PATH:"$HOME"/.bin

# set neovim as default editor
export EDITOR=nvim

trysource "~/.config/bash/host/$(hostname).bash"

# i do not need it anymore
unset trysource


