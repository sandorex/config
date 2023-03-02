#!/bin/bash
#
# aliases.bash - aliases for bash

alias reload-bash='source ~/.bashrc'

alias ls='ls --color=auto'
alias l='ls -l --color=auto'
alias ll='ls -al --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'

# tmux aliases
if command -v tmux &> /dev/null; then
    alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'

    alias msg='tmux display-message -d 0'
    alias lses='tmux list-session'

    function kses() {
        tmux kill-session -t "${1:-$USER}"
    }

    if [[ -n "$TMUX" ]]; then
        # prevents me from destroying the session all the goddamn time
        alias exit='tmux detach'
        alias detach='tmux detach'
    fi
fi

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

