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

abbr-add g 'git'

abbr-add ts 'tmux-select'
abbr-add btb 'toolbox'
abbr-add bdb 'distrobox'

abbr-add '-' 'cd -'

if command -v bat &>/dev/null; then
    alias cat='bat'
fi

if command -v distrobox-host-exec &>/dev/null; then
    abbr-add 'h' 'distrobox-host-exec'
fi

alias ls='ls -F --color=auto'
alias l='ls -aF --color=auto'
alias ll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# termux aliases
if command -v termux-setup-storage &>/dev/null; then
    alias reload-termux='termux-reload-settings'
fi

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
