#!/bin/sh
#
# https://github.com/sandorex/config
# contains aliases for bash/zsh shells

# make compdef a noop on bash
if [[ ! -v ZSH_VERSION ]]; then
    compdef() { :; }
fi

alias e="$EDITOR1"
alias ee="$EDITOR2"
alias eee="$EDITOR3"
alias se="sudo -e"
alias edit="$EDITOR1"
alias s='sudo'
alias t='task'
alias g='git'
alias cg='cgit'; compdef cg='git'
alias f="$FILE_MANAGER";

# use bat if available
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
fi

# use lsd if available
if command -v lsd &>/dev/null; then
    ls() { lsd -F "$@"; }
    l() { lsd -aF "$@"; }
    ll() { lsd -alF "$@"; }
else
    ls() { command ls -F --color=auto "$@"; }
    l() { ls -aF --color=auto "$@"; }
    ll() { ls -alFh --color=auto "$@"; }
fi

if command -v zellij &>/dev/null; then
    # quickly spin up a layout
    alias zl='zellij --layout'
fi

if [[ -v DISTROBOX_ENTER_PATH ]]; then
    alias h='distrobox-host-exec'
fi

# make dot without arguments list directory, otherwise just pass args through
_dot() {
    if [ "$#" -eq 0 ]; then
        # as im not using an alias above this should use proper arguments with
        # no duplicated codes
        ls
        # shopt -s expand_aliases
        # l
        # ls -F --color=auto
    else
        \. "$@"
    fi
}

alias -- '-'='cd -'
alias -- '.'='_dot'
alias -- '..'='cd ..'
alias -- '...'='cd ../..'
alias -- '....'='cd ../../..'

alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences
alias isodate="date +'%Y%m%dT%H%M'"

# quick monitor brightness control
alias m='monb'
alias day='monb day'
alias night='monb night'

# function aliases
rcp() {
    # -a = -rlptgoD
    #   -r = recursive
    #   -l = copy symlinks as symlinks
    #   -p = preserve permissions
    #   -t = preserve mtimes
    #   -g = preserve owning group
    #   -o = preserve owner
    # -z = use compression
    # -P = show progress on transferred file
    # -J = don't touch mtimes on symlinks (always errors)
    rsync -azPJ \
        --include=.git/ \
        --filter=':- .gitignore' \
        --filter=":- ~/.config/git/ignore" \
        "$@"
}; compdef rcp=rsync

# fuzzy cd, required fd
fcd() {
    local dir
    dir="$(fd -td -tl --follow --hidden --max-depth 5 "$@" | fzf)" && cd "${dir:?}" || exit 1
}

