#!/usr/bin/env bash
#
# interactive.sh - ran in interactive shells after initialization

# allows ^S usage, legacy stuff
stty -ixon

# load the console theming if dumb terminal
if [[ "$TERM" == "console" ]]; then
    source "$AGSHELLDIR/console-theming.sh"
fi

if [[ -z "$ZSH_VERSION" ]]; then
    # dummy to use compdef only on zsh
    compdef() { :; }

    # i disabled abbreviation for bash currently until i fix them
    abbr-clear() { :; }

    abbr-add() {
        # shellcheck disable=SC2139
        alias -- "$1"="$2"
    }
else
    source "$AGSHELLDIR"/plugins/sha-abbr/sha-abbr.zsh
fi

source "$AGSHELLDIR"/aliases.sh

# load additional custom shell agnostic stuff
if [[ -d "$AGSHELLDIR/custom" ]]; then
    for i in "$AGSHELLDIR"/custom/*.sh; do
        source "$i"
    done
fi

# load additional custom shell specific stuff
if [[ -d "$SHELLDIR/custom" ]]; then
    for i in "$SHELLDIR"/custom/*.sh; do
        source "$i"
    done
fi

unset i
