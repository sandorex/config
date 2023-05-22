#!/usr/bin/env bash
#
# silverblue.sh - silverblue setup

set -e

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

log() {
    echo "$(tput setaf 4)$1$(tput sgr0)"
}

log "Nuking systemd-oomd.service, may require superuser permission"
./extras/fedora-disable-oomd.sh

log "Setting up gnome using dconf"
./extras/setup-gnome-dconf.sh

echo
# shellcheck disable=SC2207
FLATPAKS=( $(grep -E -v '(^\s*#)|(^\s*$)' ./extras/flatpaks.list | xargs) )
log "Installing flatpaks"
flatpak install -y "${FLATPAKS[@]}"

echo
log "Installing dotfiles modules"

# scripts
../bin/install.sh

# other commonly used software
../git/install.sh
../ssh/install.sh

../bash/install.sh
../zsh/install.sh

../nvim/install.sh
../tmux/install.sh
../zellij/install.sh
../nano/install.sh
../wezterm/install.sh
../glow/install.sh

