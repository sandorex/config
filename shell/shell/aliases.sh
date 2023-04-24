#!/bin/sh
#
# aliases.sh - aliases for bash and zsh
#
# this script is sourced by both bash and zsh, beware of bashisms

[[ -n "$ZSH_VERSION" ]] && abbr-clear

# macro to create aliases and abbreviations without duplicated code
abbr() {
    if [[ -n "$ZSH_VERSION" ]]; then
        # shellcheck disable=SC2086
        abbr-add $1 $2
    else
        # shellcheck disable=SC2139
        alias -- "$1=$2"
    fi
}

abbr e "$EDITOR"
abbr s 'sudo'
abbr se 'sudo -e'

abbr '-' 'cd -'

# -F adds character to symbolize type of file, directory is a slash
# star for an executable.. etc
alias ls='ls -F --color=auto'
alias l='ls -lF --color=auto'
alias ll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

