#!/usr/bin/env zsh
#
# jobs-switcher.zsh - allows quick job switching with ^Z

# makes ctrl z run fg
_job-switch() {
    emulate -LR zsh

    fg
    zle redisplay
}
zle -N _job-switch
bindkey '^Z' _job-switch

