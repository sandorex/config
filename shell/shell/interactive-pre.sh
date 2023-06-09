#!/usr/bin/env bash
#
# interactive-pre.sh - ran in interactive shells after non-interactive.sh

# source container specific file
[[ -f "$AGSHELLDIR/distrobox/${CONTAINER_ID}.sh" ]] && source "$AGSHELLDIR/distrobox/${CONTAINER_ID}.sh"

# source system only file
if [[ -z "$CONTAINER_ID" ]] && [[ -z "$container" ]]; then
    source "$AGSHELLDIR/system.sh"
fi

