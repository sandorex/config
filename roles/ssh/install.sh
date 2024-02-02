#!/bin/bash
#
# install.sh - copies ssh config file

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

HOST=$(hostname)
mkdir -p "$HOME/.ssh/_"
mkdir -p "$HOME/.ssh/_$HOST"

util copy ./config "$HOME"/.ssh/config

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

