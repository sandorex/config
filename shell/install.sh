#!/usr/bin/env bash
#
# install.sh - links common shell scripts

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "agnostic shell config already installed"
    exit
fi

# link the shell dir
util link -a "$HOME"/.config/shell ./shell

touch .installed

