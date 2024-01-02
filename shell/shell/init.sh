#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# initialization, ran by shells but not sourced!

# it seems xwayland apps hate it when the clipboard is empty so this fills it on system startup
if command -v clip &>/dev/null; then
    echo -n " " | clip
fi

