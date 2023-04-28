#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z
#
# fzf is required

# makes ctrl z on empty buffer run fg
fg-switcher() {
    emulate -LR zsh

    job_count=$(jobs | wc -l)
    if [[ $#BUFFER -eq 0 ]] && [[ "$job_count" -ne 0 ]]; then
        if [[ "$job_count" -gt 1 ]]; then
            job_id=$(jobs | fzf | gawk 'match($0, /\[([0-9]+)\] .*/, g) { print "%" g[1] }')
            fg "$job_id"
        else
            fg
        fi
        zle redisplay
    else
        zle push-input
    fi
}
zle -N fg-switcher
bindkey '^Z' fg-switcher
