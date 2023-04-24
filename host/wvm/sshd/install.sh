#!/usr/bin/env bash
#
# install.sh - script that installs sshd configs
#
# REQUIRES ROOT

# rerun as root if not root
if [[ "$(id -u)" != "0" ]]; then
    exec sudo "$0"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$DIR"/sshd_config.d/* /etc/ssh/sshd_config.d/

