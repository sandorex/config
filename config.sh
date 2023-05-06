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
if ! command -v util &>/dev/null; then
    export PATH="$PATH:$ROOT/bin/bin"
fi

export STATE_DIR="$ROOT/state"
is-installed() {
    [[ ! -d "$STATE_DIR" ]] && mkdir -p "$STATE_DIR"

    if [[ -e "$STATE_DIR/$1" ]]; then
        return 0
    else
        touch "$STATE_DIR/$1"
        return 1
    fi
}

