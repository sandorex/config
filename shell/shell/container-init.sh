#!/usr/bin/env bash
#
# http://github.com/sandorex/config
# init script for containers (toolbx/distrobox)

# make sure the system and container have the same hostname
host_hostname="$(distrobox-host-exec hostname)"
if [[ "$(hostname)" != "$host_hostname" ]]; then
    sudo hostname "$host_hostname"
fi
