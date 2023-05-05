#!/bin/sh
#
# aliases.sh - aliases for bash and zsh
#
# this script is sourced by both bash and zsh, beware of bashisms

if [[ -z "$ZSH_VERSION" ]]; then
    # dummy to use compdef only on zsh
    compdef() { :; }
fi

# clear previous abbreviations just in case
abbr-clear

abbr-add e "$EDITOR"

abbr-add s 'sudo'
abbr-add se 'sudo -e'

abbr-add g 'git'

abbr-add ts 'tmux-select'
abbr-add box 'toolbox'

abbr-add '-' 'cd -'

# -F adds character to symbolize type of file, directory is a slash
# star for an executable.. etc
alias ls='ls -F --color=auto'
alias l='ls -aF --color=auto'
alias ll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

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

# termux aliases
if command -v termux-setup-storage; then
    alias reload-termux='termux-reload-settings'
fi

