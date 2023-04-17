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

PATH="$PATH:$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
PATH="/home/sandorex/.local/share/fnm:$PATH"
eval "`fnm env`"

export PATH
# loads the actual configuration

# set neovim as default editor
export EDITOR=nvim
export SUDO_EDITOR=nvim

# set ls colors
eval `dircolors --sh ~/.shell/gruvbox.dircolors`

trysource "~/.shell/host/$(hostname).sh"

# i do not need it anymore
unset trysource

