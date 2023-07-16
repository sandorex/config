#!/usr/bin/env bash
#
# daily.sh - creates the daily container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=daily
CONTAINER_IMAGE='registry.fedoraproject.org/fedora-toolbox:38'
CONTAINER_SETUP_SCRIPT='fedora-toolbox.sh'

# all the logic happens inside the common script
source common.sh

