#!/usr/bin/env bash
#
# interactive-pre.sh - ran in interactive shells after non-interactive.sh

# TODO rework this whole system, its a mess

source "$AGSHELLDIR/distro-icon.sh"

if [[ -n "$container" ]]; then
    if [[ -f "/run/.containerenv" ]]; then
        CONTAINER_NAME="$(perl -lne 'print $1 if /name="(\w+)"/' < /run/.containerenv)"
    else
        CONTAINER_NAME='unknown'
    fi

    # file that contains globals that should be known to containers
    source "$AGSHELLDIR/.shenv"

    # source container specific file
    [[ -f "$AGSHELLDIR/distrobox/${CONTAINER_NAME}.sh" ]] && source "$AGSHELLDIR/distrobox/${CONTAINER_NAME}.sh"
else
    # this is only sourced in non container environment (system)
    source "$AGSHELLDIR/system.sh"
fi

