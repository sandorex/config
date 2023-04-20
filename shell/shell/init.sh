#!/bin/sh
#
# init.sh - generic init for posix compliant shells

trysource() {
    if test -f "$1"; then
        \. "$1"
    fi
}

# load aliases
\. ~/.shell/aliases.sh

# load linux terminal theming
\. ~/.shell/bare-terminal-theming.sh

# i do not need it anymore
unset trysource

