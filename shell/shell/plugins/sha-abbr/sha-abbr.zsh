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

    # reset it to empty
    EXPANDED=

    # skip if buffer is empty, and if last character is a whitespace
    if [[ ! $#BUFFER == 0 ]] && [[ ! $BUFFER[-1] == [[:space:]] ]]; then
        # limit abbrevs to 6 characters
        if [[ "$#BUFFER" -le 6 ]]; then
            # uses buffer as array key verbatim
            EXPANDED=$_abbrevs[$BUFFER]
        fi

        # if nothing is found then try using buffer until the cursor as the key
        if [[ -z "$EXPANDED" ]]; then
            # limit abbrevs to 6 characters
            if [[ "$CURSOR" -gt 6 ]]; then
                return
            fi

            EXPANDED=$_abbrevs[${BUFFER:0:$CURSOR}]

            # if expansion isnt empty and the cursor is on a space to prevent
            # expansion of a letter in middle of a word which is annoying
            if [[ -n "$EXPANDED" ]] && [[ "${BUFFER[$(( $CURSOR + 1 ))]}" == [[:space:]] ]]; then
                # remove the part before expansion but keep the rest
                # i am not adding a space before cause it will be added by the
                # self-insert
                BUFFER="$EXPANDED${BUFFER:$CURSOR}"

                # move cursor to end of the expansion
                CURSOR=$#EXPANDED

                # return non-zero to signify space should not be inserted
                return 1
            fi
        else
            # set buffer
            BUFFER=$EXPANDED

            # move cursor to the end
            CURSOR=$#EXPANDED
        fi
    fi
}

_abbr-space-n-expand() {
    emulate -LR zsh

    if _abbr_try_expand; then
        # insert the space
        zle self-insert
    fi

    zle redisplay
}
zle -N _abbr-space-n-expand
bindkey ' ' _abbr-space-n-expand

_abbr-enter-n-expand() {
    emulate -LR zsh

    _abbr_try_expand || true

    zle redisplay
    zle accept-line
}
zle -N _abbr-enter-n-expand
bindkey '^M' _abbr-enter-n-expand

# enter space without expansion
bindkey "^ " magic-space

# do not expand in search
bindkey -M isearch " " magic-space
