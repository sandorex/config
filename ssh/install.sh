#!/bin/bash
#
# install.sh - copies ssh config file

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

source ../config.sh

if is-installed ssh; then
    exit
fi

HOST=$(hostname)
mkdir -p "$HOME"/.ssh
mkdir -p "$HOME/.ssh/_$HOST"
ln -s "_$HOST" "$HOME/.ssh/_$HOST.toolbox"

copy ./config "$HOME"/.ssh/config

