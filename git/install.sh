#!/bin/bash
#
# install.sh - links git config and sets the identity

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

CONFIG="$(basename "$(realpath "$(dirname "${BASH_SOURCE[0]}")")")"
if [[ -f "$HOME/.dotfiles-state/$CONFIG" ]] && [[ -z "$REINSTALL" ]]; then
    echo "$CONFIG config already installed"
    exit
fi

# TODO ask the user for username / email, but gum is not available here!
if [[ -z "$GIT_USERNAME" ]] || [[ -z "$GIT_EMAIL" ]]; then
    echo "Please set GIT_USERNAME and GIT_EMAIL for git identity"
    exit 1
fi

util link -a "$HOME"/.gitconfig ./gitconfig
util link -a "$HOME"/.git-template ./template

echo "Setting git identity"
echo "Username: '$GIT_USERNAME'"
echo "Email: '$GIT_EMAIL'"

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

mkdir -p "$HOME/.dotfiles-state"
touch "$HOME/.dotfiles-state/$CONFIG"

