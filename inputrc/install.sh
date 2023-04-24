#!/bin/bash
#
# install.sh - links inputrc config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed inputrc; then
    exit
fi

link -a "$HOME"/.inputrc ./inputrc

