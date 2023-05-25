#!/usr/bin/env bash
#
# daily.sh - creates the daily container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=${1:-daily}
CONTAINER_HOSTNAME="$(hostname).toolbox"
IMAGE='registry.fedoraproject.org/fedora-toolbox'
IMAGE_VERSION=38
ENV=( 'PROMPT_COLOR=5' 'WEZTERM_PREFIX=' )

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

