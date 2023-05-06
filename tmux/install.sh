#!/bin/bash
#
# install.sh - links tmux configuration

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "tmux config already installed"
    exit
fi

util link -a "$HOME"/.config/tmux ./tmux

touch .installed

