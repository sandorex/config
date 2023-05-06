#!/usr/bin/env bash
#
# interactive-pre.sh - ran in interactive shell before initialization

# load the console theming if dumb terminal
if [[ "$TERM" == "console" ]]; then
    source "$AGSHELLDIR/console-theming.sh"
fi

if [[ -z "$ZSH_VERSION" ]]; then
    # dummy to use compdef only on zsh
    compdef() { :; }

    # i disabled abbreviation for bash currently until i fix them
    abbr-clear() { :; }

    abbr-add() {
        # shellcheck disable=SC2139
        alias -- "$1"="$2"
    }
else
    source "$AGSHELLDIR"/plugins/sha-abbr/sha-abbr.zsh
fi

# clear previous abbreviations just in case
abbr-clear

abbr-add e "$EDITOR"

abbr-add s 'sudo'
abbr-add se 'sudo -e'

abbr-add g 'git'

abbr-add ts 'tmux-select'
abbr-add tb 'toolbox'
abbr-add b 'box'
abbr-add be 'box enter'

abbr-add '-' 'cd -'

alias ls='ls -F --color=auto'
alias l='ls -aF --color=auto'
alias ll='ls -alF --color=auto'
alias diff='diff --report-identical-files --color=auto'
alias grep='grep --color=auto'
alias rcat='cat -A' # safely read escape sequences

alias cal='cal -3'

# termux aliases
if command -v termux-setup-storage; then
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

