#!/bin/bash
#
# install.sh - links .bin directory

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sfb "$DIR"/bin "$HOME"/.bin

