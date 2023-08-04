#!/usr/bin/env bash
#
# ubuntu.sh - creates the ubuntu container in distrobox

set -eu

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export CONTAINER_NAME=${1:-ubuntu}
export CONTAINER_IMAGE='ubuntu:latest'
export CONTAINER_SETUP_SCRIPT='ubuntu.sh'

# all the logic happens inside the common script
./common.sh

