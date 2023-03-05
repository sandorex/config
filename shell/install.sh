#!/bin/bash
#
# install.sh - links common shell scripts

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

# link the shell dir
link ./shell "$HOME"/.shell

