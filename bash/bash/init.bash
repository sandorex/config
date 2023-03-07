#!/bin/bash
# the beginning and the end

alias reload-shell='source ~/.bashrc'
alias reload-bash='source ~/.bashrc'

function trysource() {
    if [[ -f "$1" ]]; then
        \. "$1"
    fi
}

# minimal prompt
export PS1="\[$(tput setaf 2)\]$\[$(tput sgr0)\] "

# load aliases
\. ~/.config/bash/aliases.bash

# load linux terminal theming
trysource ~/.shell/bare-terminal-theming.sh

export PATH=$PATH:"$HOME"/.bin

# set neovim as default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# set ls colors
[ -f ~/.shell/gruvbox.dircolors ] && eval `dircolors --sh ~/.shell/gruvbox.dircolors`

trysource "~/.config/bash/host/$(hostname).bash"

# i do not need it anymore
unset trysource

