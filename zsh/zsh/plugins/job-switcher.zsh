#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z
#
# gum is required

# makes ctrl z run fg
fg-switcher() {
    emulate -LR zsh

    # NOTE: zsh 'jobs' command does not care about pipes
    local jobs=$(cat =(jobs))
    local count=$(echo "$jobs" | wc -l)
    if [[ "$count" -eq 1 ]]; then
        fg
    elif [[ "$count" -gt 1 ]]; then
        job_id=$(echo "$jobs" | gum choose | gawk 'match($0, /\[([0-9]+)\]/, g) { print "%" g[1] }')
        fg "$job_id"
    fi

    zle redisplay
}
zle -N fg-switcher
bindkey '^Z' fg-switcher

