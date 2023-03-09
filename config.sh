#!/bin/bash
#
# config.sh - common settings

ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

GIT_USERNAME="$USER ($(hostname))"
GIT_EMAIL="rzhw3h@gmail.com"

# add tools and scripts to path
export PATH="$ROOT"/bin/bin/util:$PATH

