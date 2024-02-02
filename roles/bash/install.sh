#!/bin/bash
#
# install.sh - links bash config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

../shell/install.sh
../profile/install.sh

util link -a "$HOME"/.inputrc ./inputrc
util link -a "$HOME"/.config/bash ./bash
util link -a "$HOME"/.bashrc "$HOME"/.config/bash/init.bash

# TODO use 'util remove'
[ -f "$HOME/.bash_profile" ] && echo "Please remove ~/.bash_profile"

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"
