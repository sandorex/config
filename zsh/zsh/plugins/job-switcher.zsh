#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z
#
# gum is required

# makes ctrl z run fg
_job-switch() {
    emulate -LR zsh

    # NOTE: zsh 'jobs' command does not care about pipes
    local jobs=$(cat =(jobs))
    local count=$(echo "$jobs" | wc -l)

    # empty text is counted as 1 line
    if [[ -z "$jobs" ]]; then
        count=0
    fi

    if [[ "$count" -eq 1 ]]; then
        if [[ $#BUFFER -gt 0 ]]; then
            # save the input
            zle push-input
        fi

        fg
    elif [[ "$count" -gt 1 ]]; then
        if [[ $#BUFFER -gt 0 ]]; then
            # save the input
            zle push-input
        fi

        job_id=$(echo "$jobs" | gum choose | gawk 'match($0, /\[([0-9]+)\]/, g) { print "%" g[1] }')
        fg "$job_id"
    fi

    zle redisplay
}
zle -N _job-switch
bindkey '^Z' _job-switch

