#!/bin/bash
#
# set-custom-centre.sh - sets custom var for the current pane focused

ID=$(tmux display-message -pF '#{=-1:window_id}')
tmux set -gq @custom_centre "#{E:@custom_centre_${ID}}"

