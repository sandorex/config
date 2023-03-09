#!/bin/bash
#
# install.sh - links neovim configuration

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link -a "$HOME"/.config/nvim ./nvim

