#!/usr/bin/env bash
# this script is a wrapper around default terminal to run with any command
# so if i dont have to write the full command each time in waybar/hyprland/.. etc

ARGS=()
if [[ "$1" == "--title" ]]; then
    ARGS+=("-T" "${2:?}")
    shift 2
fi

kitty "${ARGS[@]}" sh -c "$*"
