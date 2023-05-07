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

util link -a "$HOME"/.config/zsh ./zsh
util link -a "$HOME"/.zshrc ./zsh/init.zsh
util link .profile "$HOME"/.zshenv # so it loads .profile automatically

touch .installed

