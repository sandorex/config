#!/bin/bash
#
# install.sh - links inputrc config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "inputrc config already installed"
    exit
fi

util link -a "$HOME"/.inputrc ./inputrc

touch .installed

