#!/bin/sh
#
# aliases.sh - aliases for bash and zsh
#
# this script is sourced by both bash and zsh, beware of bashisms

# clear previous abbreviations just in case
abbr-clear

abbr-add e "$EDITOR"
abbr-add s 'sudo'
abbr-add se 'sudo -e'
abbr-add ts 'tmux-select'

abbr-add '-' 'cd -'

abbr-add g 'git'

# -F adds character to symbolize type of file, directory is a slash
# star for an executable.. etc
alias ls='ls -F --color=auto'
alias l='ls -F --color=auto'
alias l.='ls -aF --color=auto'
alias ll='ls -lF --color=auto'
alias lll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

