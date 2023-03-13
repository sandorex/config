#!/bin/sh
#
# update-extras.sh <extras...> - updates extras for tmux

ID=$(tmux display-message -pF '#{=-1:window_id}')
for i in "${1:?}"; do
    tmux set -g "@${i}" "$(tmux display -p "#{@${i}-${ID}}")"
done

