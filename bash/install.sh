#!/bin/bash
#
# install.sh - links bash config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed bash; then
    exit
fi

../inputrc/install.sh
../shell/install.sh

link -a "$HOME"/.config/bash ./bash
link -a "$HOME"/.bashrc "$HOME"/.config/bash/init.bash

