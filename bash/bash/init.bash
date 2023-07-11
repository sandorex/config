#!/usr/bin/env bash
#
# init.bash - init file for bash, either loaded from bashrc or ran directly

export SHELLDIR="$HOME/.config/bash"

source "${AGSHELLDIR:-$HOME/.config/shell}/non-interactive.sh"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

source "$AGSHELLDIR/interactive-pre.sh"

alias reload-shell='source ~/.bashrc'
alias reload-bash='source ~/.bashrc'

# updates LINES & COLUMN
shopt -s checkwinsize

# append to history
shopt -s histappend

# if a history substitution fails the prompt will just retain the original text
shopt -s histreedit

# do not automatically execute substitution from history
shopt -s histverify

HISTFILE=~/.bash_history
HISTSIZE=1000000
HISTTIMEFORMAT="[%F %T %Z]"

# updates history every command
#PROMPT_COMMAND="history -a; history -c; history -r;"

# ignore duplicate commands and those that start with space
HISTCONTROL='ignoreboth'

# as bash cant really do right aligned prompt im just printing next line with center alignment
__center_align_printf() {
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# minimal prompt
__prompt_cmd() {
    code=$?
    if [ "$code" -ne 0 ]; then
        tput setaf 1
        __center_align_printf "Exited with non-zero code $code"
        tput sgr0
    fi

    # set title
    echo -en "\033]0;$(pwd)\a"
}

PROMPT_COMMAND="__prompt_cmd ; $PROMPT_COMMAND"
PS1='\[$(tput setaf 2)\]$\[$(tput sgr0)\] '

if [[ -n "$IN_CONTAINER" ]]; then
    PS1="\[$(tput setaf 4)\]󰡖 \[$(tput sgr0)\]$PS1"
fi

# enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source "$AGSHELLDIR/interactive-post.sh"

"$HOME"/.config/shell/init.sh
