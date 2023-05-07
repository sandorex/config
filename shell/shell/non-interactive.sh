#!/usr/bin/env bash
#
# non-interactive.sh - ran in non interactive and interactive shell before init

# prefer nvim if it's available
if command -v nvim &>/dev/null; then
    export EDITOR=nvim
fi

