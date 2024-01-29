#!/usr/bin/env bash
#
# non-interactive.sh - ran in non interactive and interactive shell before init

# if running distrobox run the init file
if [[ -n "$container" ]]; then
    "$AGSHELLDIR/container-non-interactive.sh"
fi
