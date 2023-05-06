#!/bin/bash
#
# install.sh - links/copies wezterm config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "wezterm config already installed"
    exit
fi

if grep -qi wsl /proc/version; then
    # TODO
    echo "For windows copy $(realpath ./wezterm/wezterm.lua) to %HOME%\\.wezterm.lua"
else
    util link -a "$HOME"/.config/wezterm ./wezterm
fi

touch .installed
