#!/bin/sh
#
# shutdown-pending.sh - shows icon if shutdown is pending, for use in tmux

# the file does not exist unless shutdown is scheduled
if [ -f /run/systemd/shutdown/scheduled ]; then
    # color it red
    printf "#[fg=red]"

    # in case the terminal does not support utf8
    if [ "$1" == "0" ]; then
        printf "[P]"
    else
        printf "⏻"
    fi

    printf "#[fg=default] "
fi

