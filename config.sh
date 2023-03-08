#!/bin/bash
#
# config.sh - common settings

GIT_USERNAME="$USER ($(hostname))"
GIT_EMAIL="rzhw3h@gmail.com"

link() {
    # if anything exists at that path rename it
    if [[ -e "$2" || -L "$2" ]]; then
        echo "Backing up '$2'"
        rm -rf "${2:?param 2 not set, almost deleted home dir}~"
        mv "$2" "$2~"
    fi

    dst=$(realpath "$1")
    echo "Linking '$2' -> '$dst'"
    ln -s "$dst" "$2"
}

