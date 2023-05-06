#!/usr/bin/env bash
#
# silverblue.sh - silverblue setup

set -e

log() {
    echo "$(tput setaf 4)$1$(tput sgr0)"
}

log "Setting up gnome using dconf"

# TODO these should be moved to a separate script like 'setup-gnome-dconf.sh'
# show minimize button
dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:minimize,close' # show minimize

dconf write /org/gnome/desktop/sound/allow-volume-above-100-percent true
dconf write /org/gnome/mutter/center-new-windows true
dconf write /org/gnome/desktop/input-sources/xkb-options ['caps:hyper'] # caps is hyper
dconf write /org/gnome/desktop/interface/gtk-enable-primary-paste false

# font stuff
dconf write /org/gnome/desktop/interface/font-hinting 'full'
dconf write /org/gnome/desktop/interface/font-antialiasing 'rgba'
dconf write /org/gnome/desktop/interface/font-name 'Noto Sans Semi-Bold 11'
dconf write /org/gnome/desktop/interface/document-font-name 'Noto Sans Semi-Bold 11'
dconf write /org/gnome/desktop/interface/monospace-font-name 'FiraCode Nerd Font Mono Medium 10'
dconf write /org/gnome/desktop/wm/preferences/titlebar-font 'Noto Sans Bold 11'

dconf write /org/gnome/desktop/interface/color-scheme 'prefer-dark' # dark mode
dconf write /org/gnome/mutter/dynamic-workspaces false # fixed num of workspaces
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 4

dconf write /org/gnome/desktop/session/idle-delay uint32 0 # screen blank time (0 = never)

dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type 'suspend' # suspend on idle
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout 1200 # 20 minutes

dconf write /org/gnome/desktop/peripherals/mouse/accel-profile 'default' # enable mouse accel

dconf write /org/gnome/desktop/peripherals/mouse/speed -0.81611570247933884 # mouse speed

echo
log "Installing dotfiles modules"

# Modules
cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

source config.sh

# so i dont have to manually clean the state
if [[ -n "$REINSTALL" ]]; then
    rm "$STATE_DIR"/*
fi

# scripts
./bin/install.sh

# other commonly used software
./git/install.sh
./ssh/install.sh

./bash/install.sh
./zsh/install.sh

./nvim/install.sh
./tmux/install.sh
./nano/install.sh
./wezterm/install.sh
./glow/install.sh

