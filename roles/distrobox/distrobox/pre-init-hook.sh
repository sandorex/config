#!/usr/bin/env bash
#
# pre init hook in distrobox

# restore hostname, it causes issues otherwise
if [[ -f "$HOME/.config/distrobox/hostname" ]]; then
    hostname "$(cat "$HOME/.config/distrobox/hostname")"
else
    echo "Unable to set hostname in the container as the hostname file is missing in home"
fi

