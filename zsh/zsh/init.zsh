#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

alias reload-shell='compinit; source ~/.zshrc'
alias reload-zsh='compinit; source ~/.zshrc'

source ~/.shell/init.sh

# the rest is only if it's an interactive shell
[[ -o interactive ]] || return

# minimal prompt
PROMPT='%F{green}%# '
RPROMPT='%(?..%B%F{red}[ %?%  ]%b)' # show exit code if not 0

## OPTIONS ##
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt extended_history append_history hist_ignore_dups hist_ignore_space

setopt no_beep      # no bell
setopt no_clobber   # do not overwrite stuff with redirection
setopt no_match     # error when glob doesnt match anything
setopt auto_cd      # cd into a dir by typing in the path
setopt notify       # report when background job finishes
setopt long_list_jobs # long format for jobs
setopt no_globdots  # TODO figure out what this does exactly
setopt extendedglob
setopt no_caseglob
setopt no_banghist  # disable !x history expansion

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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

## KEYBINDINGS ##
# left / right arrow keys
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

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

