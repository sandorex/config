#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z
#
# gum is required

# makes ctrl z run fg
fg-switcher() {
    emulate -LR zsh

    # wc -l counts very unreliably so i am using awk
    local count=$(jobs | awk 'END { print NR }')
    if [[ "$count" -eq 1 ]]; then
        fg

        zle redisplay
    elif [[ "$count" -gt 1 ]]; then
        job_id=$(jobs | gum choose | gawk 'match($0, /\[([0-9]+)\]/, g) { print "%" g[1] }')
        fg "$job_id"

        zle redisplay
    fi
}
zle -N fg-switcher
bindkey '^Z' fg-switcher
