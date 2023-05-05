#!/bin/sh
#
# path.sh - sets path for the shell (ran in non interactive shells too)

export DOTFILES="$HOME/.dotfiles"

export GOPATH="$HOME/.golang"

PATH="$PATH:$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$GOPATH/bin"
PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# prepend fnm to use its symlinks first
PATH="$HOME/.local/share/fnm:$PATH"
if command -v fnm >/dev/null; then
    eval "$(fnm env)"
fi

export PATH

# set neovim as default editor
# nano is default unless nvim exists or sudo
EDITOR=nano

if command -v nvim &>/dev/null; then
    EDITOR=nvim
fi

export EDITOR
export SUDO_EDITOR=nano

# set ls colors
eval "$(dircolors --sh ~/.config/shell/gruvbox.dircolors)"
