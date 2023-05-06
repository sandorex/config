#!/bin/bash
#
# install.sh - links .profile config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo ".profile config already installed"
    exit
fi

util link -a "$HOME"/.profile ./profile

touch .installed
