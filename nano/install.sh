#!/bin/bash
#
# install.sh - links nano directory
#
# TODO copy to root user too!

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

link -a "$HOME"/.config/nano ./nano

