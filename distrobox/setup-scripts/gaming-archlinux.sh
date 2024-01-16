#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# arch container for gaming bootstrap

set -eu

IMAGE="docker.io/library/archlinux:latest"
CONTAINER_NAME="${1:-gaming}"

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
