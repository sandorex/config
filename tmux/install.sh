#!/bin/bash
#
# install.sh - links tmux configuration

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed tmux; then
    exit
fi

link -a "$HOME"/.config/tmux ./tmux

