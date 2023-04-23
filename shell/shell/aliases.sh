#!/bin/sh
#
# aliases.sh - aliases for bash and zsh

alias e='nvim'
alias se='sudo -e'

alias -- -='cd -'

alias ls='ls -F --color=auto'
alias l='ls -lF --color=auto'
alias ll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# tmux aliases
if command -v tmux &> /dev/null; then
    if test -n "$TMUX"; then
        alias reload-tmux='tmux source-file ~/.config/tmux/tmux.conf'
        alias msg='tmux display-message -d 0'
        alias detach='tmux detach'
    fi

    alias lses='tmux list-session'

    kses() {
        tmux kill-session -t "${1:-$USER}"
    }
fi

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

