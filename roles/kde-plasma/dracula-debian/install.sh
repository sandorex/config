#!/usr/bin/env bash
#
# install.sh - installs the dracula-debian theme

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

echo "Installing the theme (experimental)"

# TODO
cp -r Dracula-debian "$HOME/.local/share/plasma/look-and-feel/"
cp -r Dracula-Solid "$HOME/.local/share/plasma/desktoptheme/"

