#!/bin/bash
#
# init.bash - init file for bash, either loaded from bashrc or ran directly

alias reload-shell='source ~/.bashrc'
alias reload-bash='source ~/.bashrc'

\. ~/.shell/init.sh

# recreating zsh rprompt with exit code if its not 0
__bash_rprompt() {
    if [ "$code" -ne 0 ]; then
        tput setaf 1
        printf "%*s" $COLUMNS "[$code]"
        tput sgr0
    fi
}

# minimal prompt
__prompt_cmd() {
    code=$?
    PS1='\[$(tput sc; __bash_rprompt; tput rc; tput setaf 2)\]$\[$(tput sgr0)\] '

    [ -n "$TMUX" ] && echo -en "\033]0;$(pwd)\a"
}

PROMPT_COMMAND='__prompt_cmd'

