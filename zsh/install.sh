#!/bin/bash
#
# install.sh - links zsh config, if the zshrc does not exist then adds a shim that loads init.zsh

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link ./zsh "$HOME"/.config/zsh

# .zshrc does not exist by default
cp ./zshrc "$HOME"/.zshrc

