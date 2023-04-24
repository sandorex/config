#!/usr/bin/env bash
#
# install.sh - links common shell scripts

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed shell; then
    exit
fi

# link the shell dir
link -a "$HOME"/.config/shell ./shell

