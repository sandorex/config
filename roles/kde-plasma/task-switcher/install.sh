#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# installs the classic task switcher

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

cp -fr ClassicKde "$HOME/.local/share/kwin/tabbox/"

# try using kcfg but if not available meh
kcfg 'kwinrc/TabBox/LayoutName' --write ClassicKde

