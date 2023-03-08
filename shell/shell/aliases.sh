#!/bin/sh
#
# aliases.sh - posix complient shell aliases

alias e='nvim'
alias se='sudo -e'

alias ls='ls --color=auto'
alias l='ls -l --color=auto'
alias ll='ls -al --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# tmux aliases
if command -v tmux &> /dev/null; then
    if test -n "$TMUX"; then
        alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'
    fi

    alias msg='tmux display-message -d 0'
    alias lses='tmux list-session'

    kses() {
        tmux kill-session -t "${1:-$USER}"
    }

    if test -n "$TMUX"; then
        alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'
        alias detach='tmux detach'
    fi
fi

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

