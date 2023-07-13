#!/usr/bin/env bash
#
# init.sh - this basically runs apps does not have anything to do with shell
#           initialization, this file should not be sourced!

# NOTE these will run only if in wezterm
wezterm-set-user-var tab_icon "$WEZTERM_ICON"
wezterm-set-user-var tab_color "$WEZTERM_COLOR"

if command -v task &>/dev/null; then
    if task current &>/dev/null; then
        echo "-- $(task current) --"
        task status
        echo "-- Task --"
    fi
fi

