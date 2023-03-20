#!/bin/bash
#
# install.sh - links git config and sets the identity

cd "$(dirname "${BASH_SOURCE[0]}")" || exit
. ../config.sh

if [[ -z "$GIT_USERNAME" ]] || [[ -z "$GIT_EMAIL" ]]; then
    echo "Please set GIT_USERNAME and GIT_EMAIL for git identity"
    exit 1
fi

link -a "$HOME"/.gitconfig ./gitconfig
link -a "$HOME"/.git-template ./template

echo "Setting git identity"
echo "Username: '$GIT_USERNAME'"
echo "Email: '$GIT_EMAIL'"

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

git config --local user.name "$GIT_USERNAME"
git config --local user.email "$GIT_EMAIL"

