#!/bin/bash
#
# config.sh - common settings

ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
export ROOT

GIT_USERNAME="$USER ($(hostname))"
export GIT_USERNAME
export GIT_EMAIL="rzhw3h@gmail.com"

# add tools and scripts to path
export PATH="$ROOT"/bin/bin/util:$PATH

