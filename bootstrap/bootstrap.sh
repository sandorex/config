#!/bin/bash
#
# bootstrap.sh - bootstraps the config
#
# run using `curl -s https://raw.githubusercontent.com/sandorex/config/master/bootstrap/bootstrap.sh | bash -s`

DIR=.dotfiles

# clone the repository
git clone https://github.com/sandorex/config ~/"$DIR"

# TODO this is hacky, maybe there is an argument to use git template?
# this is going to break if there is any more git hooks
# link pre commit script
ln -s ../git/template/hooks/pre-commit ~/config/.git/hooks/pre-commit
