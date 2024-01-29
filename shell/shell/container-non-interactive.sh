#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# non-interactive shell init file for containers

# make sure the system and container have the same hostname
host_hostname="$(distrobox-host-exec hostname)"
if [[ "$(hostname)" != "$host_hostname" ]] && [[ -n "$host_hostname" ]]; then
    sudo hostname "$host_hostname"
fi
