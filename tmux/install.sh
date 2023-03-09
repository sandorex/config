#!/bin/bash
#
# install.sh - links tmux configuration

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link -a "$HOME"/.config/tmux ./tmux

