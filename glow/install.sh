#!/bin/bash
#
# install.sh - links glow config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "glow config already installed"
    exit
fi

link -a "$HOME"/.config/glow ./glow

touch .installed

