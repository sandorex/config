#!/usr/bin/env bash
#
# kinoite.sh - kinoite setup

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# common code between variants
source ./extras/fedora-ostree-common.sh

# run common stuff
common-pre

log 'Setting up KDE Plasma TODO'

# baloo sucks
log 'Disabling Baloo indexer permanently'
balooctl suspend
balooctl disable
balooctl purge # deletes index database

common-post

