#!/bin/bash
#
# install.sh - links nano directory
#
# TODO copy to root user too!

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "nano config already installed"
    exit
fi

util link -a "$HOME"/.config/nano ./nano

touch .installed
