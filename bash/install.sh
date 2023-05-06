#!/bin/bash
#
# install.sh - links bash config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "Bash config already installed"
    exit
fi

../inputrc/install.sh
../shell/install.sh

util link -a "$HOME"/.config/bash ./bash
util link -a "$HOME"/.bashrc "$HOME"/.config/bash/init.bash

touch .installed
