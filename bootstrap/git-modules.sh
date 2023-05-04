#!/usr/bin/env bash
#
# submodules.sh - fetches git submodules

ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")/../..")

git -C "$ROOT" submodule update --init --recursive
