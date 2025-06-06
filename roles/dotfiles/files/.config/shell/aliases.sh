#!/bin/sh
#
# https://github.com/sandorex/config
# contains aliases for bash/zsh shells

# many scripts in /etc/profile.d/ set aliases and they interfere
unalias -a

# make compdef a noop on bash
if [[ -z "$ZSH_VERSION" ]]; then
    compdef() { :; }
fi

# WARNING edit fish aliases then copy changes here!
alias a=arcam
alias e="$EDITOR1"
alias ee="$EDITOR2"
alias eee="$EDITOR3"
alias se="sudo -e"
alias s='sudo'
alias g='git'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git l'
alias gll='git ll'
alias gs='git status'
alias gss='git show'
alias ga='git add'
alias gau='git add -u'
alias gap='git add --patch'
alias gr='git restore'
alias gri='git rebase -i'
alias grm='git rm --cached'
alias gc='git diff --check'
alias gcs='git diff --staged --check'
alias gcc='git commit'
alias gm='git merge --no-commit --squash'
alias f="$FILE_MANAGER"
alias mv='mv -i' # safe mv, ask on overwrite

# intentionally different command so i know if i am trashing or deleting
# NOTE: requires gvfs
alias t='gio trash'
alias trash='gio trash'
alias trash-list='gio trash --list'
alias trash-restore='gio trash --restore'

# use bat if available
if command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
fi

# use lsd if available
if command -v lsd &>/dev/null; then
    function ls() { lsd -Ft "$@"; }
    function lls() { lsd -Ftl "$@"; }
    function l() { lsd -aFt "$@"; }
    function ll() { lsd -alFt "$@"; }
else
    function ls() { command ls -Ft --color=auto "$@"; }
    function lls() { command ls -Ftl --color=auto "$@"; }
    function l() { command ls -aFt --color=auto "$@"; }
    function ll() { command ls -alFht --color=auto "$@"; }
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

