#!/usr/bin/env bash
#
# init.sh - this basically runs apps does not have anything to do with shell
#           initialization, this file should not be sourced!

# automatically sets toolbox hostname
if [[ "$(hostname)" == "toolbox" ]]; then
    source "$DOTFILES"/.shenv

    sudo hostname "$SH_HOSTNAME.toolbox"
    echo "$SH_HOSTNAME.toolbox" | sudo tee /etc/hostname >/dev/null
fi

# TODO im not gonna remove this right now as i have to recreate the containers then
wezterm-set-user-var window_prefix "${WEZTERM_PREFIX:-}"
wezterm-set-user-var tab_icon "${WEZTERM_PREFIX:-}"
wezterm-set-user-var tab_color "${WEZTERM_ICON_COLOR:-gray}"

