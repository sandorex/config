#!/usr/bin/env bash
#
# fedora-toolbox-38 containr init file

# automatically sets toolbox hostname
if [[ "$(hostname)" == "toolbox" ]]; then
    # TODO remove shenv and just make a .hostname file
    source "$DOTFILES"/.shenv

    sudo hostname "$SH_HOSTNAME-box"
    echo "$SH_HOSTNAME-box" | sudo tee /etc/hostname >/dev/null
fi

