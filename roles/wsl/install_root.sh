#!/usr/bin/env bash
#
# install_root.sh - copies wsl conf file

# check for root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script requires root"
    exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

cp -f ./wsl.conf /etc/wsl.conf

