#!/bin/bash
#
# install.sh - links .bin directory

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed bin; then
    exit
fi

link -a "$HOME"/.bin ./bin

