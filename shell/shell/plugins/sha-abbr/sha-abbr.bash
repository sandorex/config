#!/usr/bin/env bash
#
# sha-abbr.bash - bash version of sha-abbr, fish like abbreviations
#
# this plugin was written to have parity between bash and zsh, if i am forced
# to use bash for some reason

declare -A _abbrevs

abbr-add() {
    _abbrevs[$1]=$2
}

abbr-clear() {
    _abbrevs=()
}

abbr-list() {
    for key in "${!_abbrevs[@]}"; do
        echo "'$key' -> '${_abbrevs[$key]}'"
    done
}

_sha_abbr_expand() {
    if [ -n "$READLINE_LINE" ] && [ ${_abbrevs[$READLINE_LINE]+_} ]; then
        EXPANSION=${_abbrevs[$READLINE_LINE]}

        # set the buffer
        READLINE_LINE=$EXPANSION

        # move the cursor
        READLINE_POINT=${#EXPANSION}
    fi
}

# this mess is the only way i found to run code and readline commands, as bash
# does not have something like zle in zsh.. it is a mess and writing plugins
# for bash is simply a pain.
#
# i used \e[xxx as it wont clash or use up keybindings

bind -x '"\e[abbrexpand":"_sha_abbr_expand"'
bind '"\e[abbraccept":accept-line'
bind '"\e[abbrspace":magic-space'

# enter expands and accepts
bind '"\C-M":"\e[abbrexpand\e[abbraccept"'

# space expands then inserts a space
bind '" ":"\e[abbrexpand\e[abbrspace"'

# ctrl space just regular space without expansion
bind '"\C- ":"\e[abbrspace"'

