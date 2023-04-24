#!/bin/bash
#
# install.sh - links/copies wezterm config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

. ../config.sh

if is-installed wezterm; then
    exit
fi

if grep -qi wsl /proc/version; then
    # TODO
    echo "For windows copy $(realpath ./wezterm/wezterm.lua) to %HOME%\\.wezterm.lua"
else
    link -a "$HOME"/.config/wezterm ./wezterm
fi
