#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# profile picture installation script
#
# installs profile picture, made for completeness sake so everything can be
# automated
#
# requires sudo, will invoke it

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

if [[ "$EUID" -eq 0 ]]; then
    echo "Please run this script as the user"
    exit 1
fi

sudo cp -f "$PWD/pfp.png" "/var/lib/AccountsService/icons/${1:-$USER}"

