#!/usr/bin/env bash
#
# daily.sh - creates the daily container in distrobox

set -eu

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export CONTAINER_NAME="${CONTAINER_NAME:-daily}"
export CONTAINER_IMAGE='registry.fedoraproject.org/fedora-toolbox:38'
export CONTAINER_SETUP_SCRIPT='fedora-toolbox.sh'

# all the logic happens inside the common script
source ./common.sh

