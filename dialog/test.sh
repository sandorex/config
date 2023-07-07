#!/usr/bin/env bash
#
# test.sh - shows example screen to test the dialog theme

DIALOGRC=""

if [[ "$1" ]]; then
    DIALOGRC="$1"
fi

export DIALOGRC

dialog \
    --backtitle "System Information" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" 0 0 4 \
    "1" "Display System Information" \
    "2" "Display Disk Space" \
    "3" "Display Home Space Utilization"

