#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

alias reload-shell='source ~/.zshrc'
source ~/.shell/init.sh

# load all plugins
source ~/.config/zsh/plugins.zsh

# minimal prompt
export PS1="$(tput setaf 2)%#$(tput sgr0) "

# this is just beginning there's plenty more to do
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

