#!/usr/bin/env bash
#
# init.sh - initializes things needed inside the dotfiles

cd "$(dirname "${BASH_SOURCE[0]}")" || exit

if [[ -n "$container" ]] && [[ ! "$FORCE" == "1" ]]; then
    cat <<EOF
This script is not meant to be ran in a container
To override this use 'FORCE=1 $0'

EOF
    exit 1
fi

echo "Initializing dotfiles.."

# update the submodules, otherwise many things will break
git submodule update --init --recursive

# TODO this maybe should be its own script that saves specific values in POSIX
# compatible format
echo "SH_HOSTNAME='$(hostname)'" > ./.shenv

