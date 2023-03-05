#!/bin/bash
#
# config.sh - common settings

GIT_USERNAME="$USER ($(hostname))"
GIT_EMAIL="rzhw3h@gmail.com"

link() {
    # if anything exists at that path rename it
    if [[ -e "$2" || -L "$2" ]]; then
        mv "$2" "$2~"
    fi

    ln -s "$(realpath "$1")" "$2"
}

