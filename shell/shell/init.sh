#!/bin/sh
#
# init.sh - generic init for posix compliant shells

trysource() {
    if test -f "$1"; then
        \. "$1"
    fi
}

# load aliases
\. ~/.shell/aliases.sh

# load linux terminal theming
\. ~/.shell/bare-terminal-theming.sh

export PATH=$PATH:"$HOME"/.bin

# set neovim as default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# set ls colors
eval `dircolors --sh ~/.shell/gruvbox.dircolors`

trysource "~/.shell/host/$(hostname).sh"

# i do not need it anymore
unset trysource

