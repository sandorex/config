#!/bin/bash
#
# install.sh - links .bin directory

cd "$(dirname "${BASH_SOURCE[0]}")"
. ../config.sh

link -a "$HOME"/.bin ./bin

