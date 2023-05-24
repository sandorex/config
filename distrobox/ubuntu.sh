#!/usr/bin/env bash
#
# ubuntu.sh - creates the ubuntu container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=ubuntu
CONTAINER_HOSTNAME="$(hostname).toolbox"
IMAGE='ubuntu'
IMAGE_VERSION=latest
ENV=( 'PROMPT_COLOR=202' )

# this does not run the setup script, that has to be done manually
distrobox create --image "$IMAGE:$IMAGE_VERSION" \
                 --name "$CONTAINER_NAME" \
                 --additional-flags "'${ENV[@]/#/-e }'" \
                 --pre-init-hooks "hostname \"$CONTAINER_HOSTNAME\""

