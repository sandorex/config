#!/bin/bash
#
# install.sh - copies ssh config file

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

source ../config.sh

mkdir -p "$HOME"/.ssh

copy ./config "$HOME"/.ssh/config

