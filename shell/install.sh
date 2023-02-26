#!/bin/bash
#
# install.sh - links common shell scripts

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link the shell dir
ln -sfb "$DIR"/shell "$HOME"/.shell

