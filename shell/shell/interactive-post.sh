#!/usr/bin/env bash
#
# interactive-post.sh - ran in interactive shells after initialization

# allows ^S usage, legacy stuff
stty -ixon

# load the console theming if dumb terminal
if [[ "$TERM" == "console" ]]; then
    source "$AGSHELLDIR/console-theming.sh"
fi

source "$AGSHELLDIR"/aliases.sh

