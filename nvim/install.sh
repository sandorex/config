#!/bin/bash
#
# install.sh - links neovim configuration

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed nvim; then
    exit
fi

link -a "$HOME"/.config/nvim ./nvim

