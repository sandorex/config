#!/usr/bin/env bash
#
# init.sh - for common non path stuff

# start server
if command -v tmux &>/dev/null; then
    tmux start-server
fi

# allows ^S usage, legacy stuff
stty -ixon

# automatically sets toolbox hostname
if [[ "$(hostname)" == "toolbox" ]]; then
    echo "Setting up toolbox hostname.."

    source "$DOTFILES"/.shenv

    sudo hostname "$SH_HOSTNAME.toolbox"
    echo "$SH_HOSTNAME.toolbox" | sudo tee /etc/hostname >/dev/null
fi
