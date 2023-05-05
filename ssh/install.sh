#!/bin/bash
#
# install.sh - copies ssh config file

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

source ../config.sh

HOST=$(hostname)
mkdir -p "$HOME"/.ssh
mkdir -p "$HOME/.ssh/_$HOST"
ln -s "_$HOST" "$HOME/.ssh/_$HOST.toolbox"

# TODO copy script is untested
cp ./config "$HOME"/.ssh/config
#copy ./config "$HOME"/.ssh/config

