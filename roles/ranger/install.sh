#!/bin/bash
#
# install.sh - links ranger config
#
# install ranger with pipx
#   pipx install ranger-fm
#   pipx inject ranger-fm pillow # for kitty img support

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

util link -a "$HOME"/.config/ranger ./ranger

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"
