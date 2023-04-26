#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

source ~/.shell/path.sh

# the rest is only if it's an interactive shell
[[ -o interactive ]] || return

# load bare console colors
source ~/.shell/bare-terminal-theming.sh

alias reload-shell='source ~/.zshrc; compinit'
alias reload-zsh='source ~/.zshrc; compinit'

# minimal prompt
PROMPT='%(?.%F{green}.%F{red})%% '
RPROMPT='%(?..%B%F{red}[ %?%  ]%b)' # show exit code if not 0

chpwd() {
    # list files on dir change
    ls --color=auto -F
}

precmd() {
    # update the title
    # this used to be in chpwd but leaving another application would leave old
    # title
    echo -en "\033]0;$(pwd)\a"
}

## OPTIONS ##
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt extended_history append_history hist_ignore_dups hist_ignore_space
# TODO save history after every command like in bash

setopt no_beep      # no bell
setopt no_clobber   # do not overwrite stuff with redirection
setopt no_match     # error when glob doesnt match anything
setopt auto_cd      # cd into a dir by typing in the path
setopt notify       # report when background job finishes
setopt long_list_jobs # long format for jobs
setopt no_globdots
setopt extendedglob
setopt no_caseglob
setopt no_banghist  # disable !x history expansion

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _ignored _files

# time commands that take longer than 10 second system/cpu time
REPORTTIME=10

# this has to be below options
autoload -Uz compinit

# generate compinit only every 8 hours
for _ in ~/.zcompdump(N.mh+8); do
    compinit
done

compinit -C

# show dotfiles with tab completion
_comp_options+=(globdots)

# load all plugins
source ~/.config/zsh/plugins.zsh

# load aliases
source ~/.shell/aliases.sh

## KEYBINDINGS ##
# ctr + left / right arrow keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# make tab on empty buffer autocomplete like cd
first-tab() {
    emulate -LR zsh

    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi
}
zle -N first-tab
bindkey '^I' first-tab

# makes ctrl z on empty buffer run fg
fg-switcher() {
    emulate -LR zsh

    job_count=$(jobs | wc -l)
    if [[ $#BUFFER -eq 0 ]] && [[ "$job_count" -ne 0 ]]; then
        if [[ "$job_count" -gt 1 ]]; then
            job_id=$(jobs | fzf | gawk 'match($0, /\[([0-9]+)\] .*/, g) { print "%" g[1] }')
            fg "$job_id"
        else
            fg
        fi
        zle redisplay
    else
        zle push-input
    fi
}
zle -N fg-switcher
bindkey '^Z' fg-switcher

# tmux messes it up so im redefining it here
bindkey '^R' history-incremental-search-backward

# delete and ctrl delete
bindkey '^[[3~' delete-char
bindkey "^[[3;5~" delete-word

# ctrl backspace
bindkey '^H' backward-delete-word

stty -ixon # enables ^Q and ^S
bindkey "^Q" push-input

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

