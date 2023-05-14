#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

export SHELLDIR="$HOME/.config/zsh"

source "${AGSHELLDIR:-$HOME/.config/shell}/non-interactive.sh"

# the rest is only if it's an interactive shell
[[ -o interactive ]] || return

alias reload-shell='source ~/.zshrc; compinit'
alias reload-zsh='source ~/.zshrc; compinit'

# little help, as i always forget them
# read more athttps://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
#
# '%(?.X.Y)' if last exit is 0 then X otherwise Y, it does not have to be '.'
# it can be anything as long as it's the same closing paren needs to be escaped
# as '%)' if used inside
#
# %f resets color to default

# ? - last exit code
# L - SHLVL
# j - background jobs
PROMPT='%(?.%F{green}.%F{red})%(1j.%U.)%%%u%(2L.%F{magenta}%L.)%f '

# shows exit code if last command exited with non-zero
RPROMPT='%(?..%F{red}[ %?%  ]%f)' # show exit code if not 0

# prepend container indicator
if [[ "$container" = "oci" ]]; then
    PROMPT="%F{4}󰡖 $PROMPT"
fi

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

setopt no_beep          # no bell
setopt no_clobber       # do not overwrite stuff with redirection
setopt no_match         # error when glob doesnt match anything
setopt auto_cd          # cd into a dir by typing in the path
setopt no_notify        # report about background jobs only before prompt
setopt long_list_jobs   # long format for jobs
setopt globdots         # match dot files with globs implicitly
setopt extendedglob
setopt no_caseglob
setopt no_banghist      # disable !x history expansion
setopt complete_in_word # complete from both ends of a word
setopt always_to_end    # move cursor to the end of completed word
setopt auto_list        # list on first tab if ambiguous completion
setopt auto_menu
setopt auto_param_slash # if param is a dir add a trailing slash

# zstyle ':completion:*' file-sort name
# zstyle ':completion:*' menu select=long
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _ignored _files

# time commands that take longer than 10 second system/cpu time
REPORTTIME=10

# zsh renamer thingy
autoload -U zmv

# this has to be below options
autoload -Uz compinit

# generate compinit only every 8 hours
for _ in "$HOME"/.zcompdump(N.mh+8); do
    compinit
done

compinit -C

# show dotfiles with tab completion
_comp_options+=(globdots)

# load all plugins
source "$SHELLDIR"/plugins/quick-sudo.zsh
source "$SHELLDIR"/plugins/job-switcher.zsh

## KEYBINDINGS ##
# ctr + left / right arrow keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# make tab on empty buffer autocomplete like cd
_first-tab() {
    emulate -LR zsh

    if [[ $#BUFFER == 0 ]]; then
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    else
        zle expand-or-complete
    fi

    zle redisplay
}
zle -N _first-tab
bindkey '^I' _first-tab

# tmux messes it up so im redefining it here
bindkey '^R' history-incremental-search-backward

# delete and ctrl delete
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' delete-word

# ctrl backspace
bindkey '^H' backward-delete-word

stty -ixon # enables ^Q and ^S
bindkey '^Q' push-input

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# run tmux-select
bindkey -s '' 'tmux-select\n'

source "$AGSHELLDIR/interactive-post.sh"

# syntax highlighting
# HAS TO BE LOADED LAST!
source "$SHELLDIR"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# startup apps and stuff
"$AGSHELLDIR"/init.sh

