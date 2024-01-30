#!/usr/bin/env bash
#
# init-i.sh - initialization of interactive shells

# allows ^S usage in keybindings, annoying as it pauses whole terminal
stty -ixon

# define color and distro icon
source "$AGSHELLDIR/util/distro-icon.sh"

# theme bare shell if ran in it
if [[ "$TERM" == "linux" ]]; then
    "$AGSHELLDIR/util/console-theming.sh"
fi

if [[ -v container ]]; then
    source "$AGSHELLDIR/container/init-i.sh"
fi
