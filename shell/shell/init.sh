#!/usr/bin/env bash
#
# init.sh - this basically runs apps does not have anything to do with shell
#           initialization, this file should not be sourced!

# start server
if command -v tmux &>/dev/null; then
    tmux start-server
fi

# automatically sets toolbox hostname
if [[ "$(hostname)" == "toolbox" ]]; then
    echo "Setting up toolbox hostname.."

    source "$DOTFILES"/.shenv

    sudo hostname "$SH_HOSTNAME.toolbox"
    echo "$SH_HOSTNAME.toolbox" | sudo tee /etc/hostname >/dev/null
fi

