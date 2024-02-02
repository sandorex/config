#!/bin/bash
#
# install.sh - links zellij config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

util link -a "$HOME"/.config/zellij ./zellij

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

