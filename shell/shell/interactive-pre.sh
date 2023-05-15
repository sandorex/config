#!/usr/bin/env bash
#
# interactive-pre.sh - ran in interactive shells after non-interactive.sh

# detect if container used further in initialization
if [[ "$container" == "oci" ]]; then
    export IN_CONTAINER=1
fi

