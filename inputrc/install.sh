#!/bin/bash
#
# install.sh - links inputrc config

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link ./inputrc "$HOME"/.inputrc
