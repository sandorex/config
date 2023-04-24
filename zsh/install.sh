#!/bin/bash
#
# install.sh - links zsh config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed zsh; then
    exit
fi

../shell/install.sh

link -a "$HOME"/.config/zsh ./zsh
link -a "$HOME"/.zshrc ./zsh/init.zsh

