#!/usr/bin/env bash
#
# https://github.com/sandore/config
# non-interactive (and interactive) shell initialization

if [[ -v container ]]; then
    source "$AGSHELLDIR/container/init.sh"
fi
