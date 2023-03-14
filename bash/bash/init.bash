#!/bin/bash
#
# init.bash - init file for bash, either loaded from bashrc or ran directly

alias reload-shell='source ~/.bashrc'
alias reload-bash='source ~/.bashrc'

\. ~/.shell/init.sh

if [[ -n "$TMUX" ]]; then
    PROMPT_COMMAND='echo -en "\033]0;$(pwd)\a"'
fi

# minimal prompt
export PS1="\[$(tput setaf 2)\]$\[$(tput sgr0)\] "

