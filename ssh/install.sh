#!/bin/bash
#
# install.sh - copies ssh config file

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "ssh config already installed"
    exit
fi

HOST=$(hostname)
mkdir -p "$HOME"/.ssh
mkdir -p "$HOME/.ssh/_$HOST"

# TODO test this
util link "_$HOST" "$HOME/.ssh/_$HOST.toolbox"

util copy ./config "$HOME"/.ssh/config

touch .installed

