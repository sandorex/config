#!/usr/bin/env bash
#
# init.sh - for common non path stuff

# start server
if command -v tmux &>/dev/null; then
    tmux start-server
fi

