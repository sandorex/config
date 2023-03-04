#!/bin/bash
#
# install.sh - links inputrc config

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# make the link but backup the file
ln -sfb "$DIR"/inputrc "$HOME"/.inputrc

