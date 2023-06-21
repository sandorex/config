#!/bin/sh
#
# aliases.sh - aliases for bash and zsh
#
# this script is sourced by both bash and zsh, beware of bashisms

alias e="$EDITOR"
alias se="sudo -e"
alias edit="$EDITOR"
alias s='sudo'

alias g='git'
alias cg='cgit'

if command -v bat &>/dev/null; then
    alias cat='bat'
fi

if command -v lsd &>/dev/null; then
    alias ls='lsd -F'
    alias l='lsd -aF'
    alias ll='lsd -alF'
else
    alias ls='ls -F --color=auto'
    alias l='ls -aF --color=auto'
    alias ll='ls -alF --color=auto'
fi

if command -v distrobox-host-exec &>/dev/null; then
    alias h='distrobox-host-exec'
fi

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

alias cal='cal -3'

# termux aliases
if command -v termux-setup-storage &>/dev/null; then
    alias reload-termux='termux-reload-settings'
fi

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
