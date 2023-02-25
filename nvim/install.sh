#!/bin/bash
#
# install.sh - links neovim configuration

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# move the directory as ln cannot overwrite it...
[ -d "$HOME/.config/nvim" ] && mv "$HOME"/.config/nvim "$HOME"/.config/nvim~
ln -sf "$DIR"/nvim "$HOME"/.config/nvim

