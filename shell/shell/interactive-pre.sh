#!/usr/bin/env bash
#
# interactive-pre.sh - ran in interactive shells after non-interactive.sh

if [[ -n "$container" ]]; then
    if [[ -f "/run/.containerenv" ]]; then
        CONTAINER_NAME="$(gawk 'match($0, /name="(.+)"/, r) { print r[1] }' /run/.containerenv)"
    else
        CONTAINER_NAME='unknown'
    fi

    # source container specific file
    [[ -f "$AGSHELLDIR/distrobox/${CONTAINER_NAME}.sh" ]] && source "$AGSHELLDIR/distrobox/${CONTAINER_NAME}.sh"


else
    # this is only sourced in non container environment (system)
    source "$AGSHELLDIR/system.sh"
fi

