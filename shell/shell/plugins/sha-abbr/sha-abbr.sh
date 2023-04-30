#!/bin/sh
#
# sha-abbr.sh - loads sha-abbr for correct shell, bash and zsh only currently

if [[ -z "$ZSH_VERSION" ]]; then
    source "${0:A:h}"/sha-abbr.zsh
elif [[ -z "$BASH" ]]; then
    DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
    source "$DIR"/sha-abbr.bash
else
    echo "Failed to load sha-abbr, invalid shell $SHELL"
fi
