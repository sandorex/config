#!/bin/sh
#
# path.sh - sets path for the shell (ran in non interactive shells too)

PATH="$PATH:$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
PATH="/home/sandorex/.local/share/fnm:$PATH"
if command -v fnm >/dev/null; then
    eval "$(fnm env)"
fi

export PATH

# set neovim as default editor
export EDITOR=nvim
export SUDO_EDITOR=nano

# set ls colors
eval "$(dircolors --sh ~/.config/shell/gruvbox.dircolors)"
