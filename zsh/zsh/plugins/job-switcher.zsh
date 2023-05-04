#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z
#
# fzf is required

# makes ctrl z run fg
fg-switcher() {
    emulate -LR zsh

    # here string inserts a newline so wc can count it properly
    local count=$(wc -l <<< "\n$(jobs)")
    if [[ "$count" -eq 2 ]]; then
        fg

        zle redisplay
    elif [[ "$count" -gt 2 ]]; then
        job_id=$(jobs | fzf | gawk 'match($0, /\[([0-9]+)\]/, g) { print "%" g[1] }')
        fg "$job_id"

        zle redisplay
    fi
}
zle -N fg-switcher
bindkey '^Z' fg-switcher
