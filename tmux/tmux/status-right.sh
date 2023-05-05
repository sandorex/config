#!/usr/bin/bash
#
# status-right.sh - right part of status bar in tmux

icons=( '' '' '󰡖')
icons_noutf=( '[SSH]' '[WSL]' '[C]' )

# $1 enables utf8 output
if [[ -z "$1" ]]; then
    icons=(${icons_noutf[@]})
fi

if [[ -n "$SSH_CONNECTION" ]]; then
    printf " %s" "${icons[0]}"
fi

if [[ -n "$WSL_DISTRO_NAME" ]]; then
    printf " %s" "${icons[1]}"
fi

if [[ "$container" == "oci" ]]; then
    printf " %s" "${icons[2]}"
fi

