#!/bin/sh
#
# aliases.sh - aliases for bash and zsh
#
# this script is sourced by both bash and zsh, beware of bashisms
#
# this file should always be sourceable without any other file

# make compdef an no op on bash
if [[ -z "$ZSH_VERSION" ]]; then
    compdef() { :; }
fi

alias e="$EDITOR"; compdef e="$EDITOR"
alias se="sudo -e"
alias edit="$EDITOR"; compdef e="$EDITOR"
alias s='sudo'; compdef s='sudo'
alias t='task'
alias g='git'; compdef g='git'
alias cg='cgit'; compdef cg='git'
alias f="$FILE_MANAGER";

# use bat if available
if command -v batcat &>/dev/null; then
    # for some reason debian renamed bat to batcat
    alias bat='batcat'
    alias cat='batcat --style=plain'
elif command -v bat &>/dev/null; then
    alias cat='bat --style=plain'
fi

if command -v lsd &>/dev/null; then
    alias ls='lsd -F'
    alias l='lsd -aF'
    alias ll='lsd -alF'
else
    alias ls='ls -F --color=auto'
    alias l='ls -aF --color=auto'
    alias ll='ls -alFh --color=auto'
fi

if command -v zellij &>/dev/null; then
    # quickly spin up a layout
    alias zl='zellij --layout'
fi

if command -v distrobox-host-exec &>/dev/null; then
    alias h='distrobox-host-exec'
fi

# little wrapper that lists the current directoy without arguments but if there
# are any then they are passed to \. aka source command
_smart_dot() {
    if [ "$#" -eq 0 ]; then
        ls -F --color=auto
    else
        \. "$@"
    fi
}

alias -- '-'='cd -'
alias -- '.'='_smart_dot'
alias -- '..'='cd ..'
alias -- '...'='cd ../..'
alias -- '....'='cd ../../..'

alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

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
