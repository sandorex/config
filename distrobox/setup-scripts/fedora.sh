#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# fedora container bootstrap

set -eu

IMAGE="registry.fedoraproject.org/fedora-toolbox:39"
CONTAINER_NAME="${1:-fedora}"

if [[ -v container ]]; then
    echo "Running distrobox inside a container is not recommended"
    exit 1
fi

# do not change the hostname, the hostname should be the same as on host inside
# the container anything else does not resolve properly and cause huge
# stuttering spikes and freezes of whole desktop environment

distrobox create --image "$IMAGE" \
                 --name "$CONTAINER_NAME" \
                 "${ARGS[@]}" \
                 --pre-init-hooks "hostname \"$(hostname)\""

# TODO
#if [[ -v RUN_CONFIG ]] && [[ -v CONTAINER_SETUP_SCRIPT ]]; then
#    echo "Running config script, this will take a while.."
#    echo
#
#    distrobox enter --name "$CONTAINER_NAME" -- "./configs/${CONTAINER_SETUP_SCRIPT}"
#fi
