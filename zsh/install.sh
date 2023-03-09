#!/bin/bash
#
# install.sh - links zsh config

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link -a "$HOME"/.config/zsh ./zsh
link -a "$HOME"/.zshrc ./zsh/init.zsh

