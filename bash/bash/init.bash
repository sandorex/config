#!/bin/bash
# the beginning and the end

function trysource() {
    file=$1
    shift
    if [[ -f "$file" ]]; then
        \. "$file" $@
    fi
}

# load tmux
if command -v tmux &> /dev/null; then
    trysource ~/.config/tmux/tmux.bash
fi

# load termux
if command -v termux-setup-storage; then
    trysource ~/.config/termux/termux.bash
fi

# i do not need it anymore
unset trysource

