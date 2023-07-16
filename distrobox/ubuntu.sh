#!/usr/bin/env bash
#
# ubuntu.sh - creates the ubuntu container in distrobox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

CONTAINER_NAME=${1:-ubuntu}
CONTAINER_IMAGE='ubuntu:latest'
CONTAINER_SETUP_SCRIPT='ubuntu.sh'

# all the logic happens inside the common script
source common.sh

