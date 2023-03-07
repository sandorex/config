#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

# TODO load common shell stuff

# load all plugins
source ~/.config/zsh/plugins.zsh

# this is just beginning there's plenty more to do
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select

