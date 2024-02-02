#!/usr/bin/env bash
#
# silverblue.sh - silverblue setup

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# common code between variants
source ./extras/fedora-ostree-common.sh

# run common stuff
common-pre

log "Setting up gnome using dconf"
./extras/setup-gnome-dconf.sh

common-post

