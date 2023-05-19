#!/bin/bash
#
# install.sh - links/copies wezterm config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

if grep -qi wsl /proc/version; then
    # TODO
    echo "For windows copy $(realpath ./wezterm/wezterm.lua) to %HOME%\\.wezterm.lua"
else
    util link -a "$HOME"/.config/wezterm ./wezterm
fi

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

