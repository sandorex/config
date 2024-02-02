#!/usr/bin/env bash
#
# install.sh - links common shell scripts

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

# link the shell dir
util link -a "$HOME"/.config/shell ./shell

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

