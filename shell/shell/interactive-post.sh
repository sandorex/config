#!/usr/bin/env bash
#
# interactive.sh - ran in interactive shells after initialization

# allows ^S usage, legacy stuff
stty -ixon

__wezterm_set_user_var() {
    if [[ -z "${TMUX}" ]] ; then
        printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(echo -n "$2" | base64)
    else
        # Note that you ALSO need to add "set -g allow-passthrough on" to your tmux.conf
        printf "\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\" "$1" $(echo -n "$2" | base64)
    fi
}

# tell wezterm that its running tmux currently
# TODO: figure out a way to reset it when leaving tmux session
if [[ -n "$TMUX" ]]; then
    __wezterm_set_user_var TMUX 1
fi

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
