#!/usr/bin/env zsh
#
# abbrevs.zsh - plugin for fish like abbrevs
#
# inspired by fish abbreviations and zsh-abbr, meant to be dead simple
#   zsh-abbr: https://github.com/olets/zsh-abbr

declare -A _abbrevs

abbr-add() {
    emulate -LR zsh

    _abbrevs[$1]=$2
}

abbr-list() {
    emulate -LR zsh

    for key value in ${(kv)_abbrevs}; do
        echo "'$key' -> '$value'"
    done
}

abbr-clear() {
    emulate -LR zsh

    _abbrevs=( )
}

_abbr_try_expand() {
    emulate -LR zsh

    # skip if buffer is empty, and if last character is a whitespace
    if [[ ! $#BUFFER == 0 ]] && [[ ! $BUFFER[-1] == [[:space:]] ]]; then
        # uses buffer as array key verbatim
        EXPANDED=$_abbrevs[$BUFFER]

        if [[ -n "$EXPANDED" ]]; then
            # set buffer
            BUFFER=$EXPANDED

            # move cursor to the end
            CURSOR=$#EXPANDED
        fi
    fi
}

abbr-space-n-expand() {
    emulate -LR zsh

    _abbr_try_expand

    # insert the space
    zle self-insert
}
zle -N abbr-space-n-expand
bindkey ' ' abbr-space-n-expand

abbr-enter-n-expand() {
    emulate -LR zsh

    _abbr_try_expand

    zle accept-line
}
zle -N abbr-enter-n-expand
bindkey '^M' abbr-enter-n-expand

# enter space without expansion
bindkey "^ " magic-space

# do not expand in search
bindkey -M isearch " " magic-space
