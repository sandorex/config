#!/bin/bash
#
# install.sh - links git config

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# make the link but backup the file
ln -sfb "$DIR"/.gitconfig "$HOME"/.gitconfig

username=${GIT_USERNAME:-"$USER ($(hostname))"}
echo "Setting up git identity"
echo "Username: '$username'"
echo "Email: '$GIT_EMAIL'"

git config user.name "$username"
git config user.email "$GIT_EMAIL"
