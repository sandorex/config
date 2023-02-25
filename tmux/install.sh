#!/bin/bash
#
# install.sh - links tmux configuration

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# move the directory as ln cannot overwrite it...
[ -d "$HOME/.config/tmux" ] && mv "$HOME"/.config/tmux "$HOME"/.config/tmux~
ln -sf "$DIR"/tmux "$HOME"/.config/tmux

