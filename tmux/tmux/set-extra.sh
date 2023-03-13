#!/bin/sh
#
# set-extra.sh <name> <value> - sets extra for tmux

ID=$(tmux display -p '#{=-1:window_id}')
tmux set -g "@${1:?}-${ID:?}" ${2:?}

# update the non numbered variable
~/.config/tmux/update-extras.sh "${1:?}"

