#!/usr/bin/env bash
#
# non-interactive.sh - ran in non interactive and interactive shell before init

# i guess i have to do it myself
source "$HOME"/.profile

# prefer nvim if it's available
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
fi

