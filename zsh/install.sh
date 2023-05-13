#!/bin/bash
#
# install.sh - links zsh config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "zsh config already installed"
    exit
fi

../shell/install.sh
../profile/install.sh

util link -a "$HOME"/.config/zsh ./zsh
util link -a "$HOME"/.zshrc ./zsh/init.zsh
util link .profile "$HOME"/.zprofile # it wont load .profile unless .zshrc is missing

# TODO write 'util remove' and 'util restore' and use it to backup these
[ -f "$HOME/.zshenv" ] && echo "Please remove ~/.zshenv"
[ -f "$HOME/.zlogin" ] && echo "Please remove ~/.zlogin"

touch .installed

