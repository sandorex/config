#!/bin/bash
#
# config.sh - common settings

ROOT=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
export ROOT

if [[ -z "$GIT_USERNAME" ]]; then
    GIT_USERNAME="$USER ($(hostname))"
    export GIT_USERNAME
fi

if [[ -z "$GIT_EMAIL" ]]; then
    export GIT_EMAIL="rzhw3h@gmail.com"
fi

# add tools and scripts to path
export PATH="$ROOT"/bin/bin/util:$PATH

