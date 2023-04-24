#!/bin/bash
#
# wvm.sh - configuration for the Work Virtual Machine

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

source config.sh

# so i dont have to manually clean the state
if [[ -n "$REINSTALL" ]]; then
    rm "$STATE_DIR"/*
fi

# scripts
./bin/install.sh

# other commonly used software
./git/install.sh
./bash/install.sh
./zsh/install.sh
./nvim/install.sh
./tmux/install.sh

