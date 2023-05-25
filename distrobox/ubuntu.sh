#!/usr/bin/env bash
#
# ubuntu.sh - creates the ubuntu container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=${1:-ubuntu}
CONTAINER_HOSTNAME="$(hostname).toolbox"
IMAGE='ubuntu'
IMAGE_VERSION=latest
ENV=( 'PROMPT_COLOR=202' 'WEZTERM_PREFIX=' )

if [[ -n "$container" ]]; then
    echo "Running distrobox inside a container is not recommended"
    exit 1
fi

# bash magic to properly format env vars
ENV=( "${ENV[@]/#/\'-e }" )
ENV=( "${ENV[@]/%/\'}" )

# shellcheck disable=SC2145
# this does not run the setup script, that has to be done manually
distrobox create --image "$IMAGE:$IMAGE_VERSION" \
                 --name "$CONTAINER_NAME" \
                 --additional-flags "${ENV[*]}" \
                 --pre-init-hooks "hostname \"$CONTAINER_HOSTNAME\""

