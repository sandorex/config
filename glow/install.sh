#!/bin/bash
#
# install.sh - links glow config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed glow; then
    exit
fi

link -a "$HOME"/.config/glow ./glow

