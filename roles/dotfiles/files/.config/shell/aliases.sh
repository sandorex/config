#!/bin/sh
#
# https://github.com/sandorex/config
# contains aliases for bash/zsh shells

# many scripts in /etc/profile.d/ set aliases and they interfere
unalias -a

# make compdef a noop on bash
if [[ ! -v ZSH_VERSION ]]; then
    compdef() { :; }
fi

alias e="$EDITOR1"
alias ee="$EDITOR2"
alias eee="$EDITOR3"
alias se="sudo -e"
alias s='sudo'
alias g='git'
alias f="$FILE_MANAGER";
alias m='tmux'

# start box container automatically and set env var if no args
function box() {
    if [[ "$#" -eq 0 ]]; then
        if [[ -v BOX_CONTAINER ]] && box exists; then
            echo "Box is already running"
            exit 0
        fi

        unset BOX_CONTAINER
        export BOX_CONTAINER="$(box start)"
    else
        command box "$@"
    fi
}

# use bat if available
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
fi

# use lsd if available
if command -v lsd &>/dev/null; then
    function ls() { lsd -F "$@"; }
    function l() { lsd -aF "$@"; }
    function ll() { lsd -alF "$@"; }
else
    function ls() { command ls -F --color=auto "$@"; }
    function l() { command ls -aF --color=auto "$@"; }
    function ll() { command ls -alFh --color=auto "$@"; }
fi

if command -v zellij &>/dev/null; then
    alias z='zellij'

    # quickly spin up a layout
    alias zl='zellij --layout'
fi

# make dot without arguments list directory, otherwise just pass args through
_dot() {
    if [ "$#" -eq 0 ]; then
        # as im not using an alias above this should use proper arguments with
        # no duplicated codes
        ls
    else
        \. "$@"
    fi
}

alias -- '-'='cd -'
alias -- '.'='_dot'
alias -- '..'='cd ..'

alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias isodate="date +'%Y%m%dT%H%M'"
alias qr="qrencode -t UTF8"

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

# fuzzy cd, requires fd
fcd() {
    local dir
    # im using cd here as fd acts weirdly with an argument
    # using fzf exact match as it makes more sense
    dir="$(test -n "$1" && cd "$1"; fd -td -tl --follow --max-depth 5 | fzf --exact)" && cd "${dir:?}"
}

# enter distrobox by default
dbx() {
    if [[ "$#" == 0 ]]; then
        command distrobox enter
    else
        command distrobox "$@"
    fi
}
