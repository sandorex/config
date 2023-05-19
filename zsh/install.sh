#!/bin/bash
#
# install.sh - links zsh config

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

../shell/install.sh
../profile/install.sh

util link -a "$HOME"/.config/zsh ./zsh
util link -a "$HOME"/.zshrc ./zsh/init.zsh
util link .profile "$HOME"/.zprofile

# TODO write 'util remove' and 'util restore' and use it to backup these
[ -f "$HOME/.zshenv" ] && echo "Please remove ~/.zshenv"
[ -f "$HOME/.zlogin" ] && echo "Please remove ~/.zlogin"

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

