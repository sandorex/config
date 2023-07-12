#!/usr/bin/env bash
#
# fedora-toolbox-38 container init file

# automatically sets toolbox hostname
if [[ "$(hostname)" != "${HOST_HOSTNAME}-box" ]]; then
    sudo hostname "${HOST_HOSTNAME}-box"
    echo "${HOST_HOSTNAME}-box" | sudo tee /etc/hostname >/dev/null
fi
