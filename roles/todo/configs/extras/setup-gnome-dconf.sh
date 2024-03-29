#!/usr/bin/env bash
#
# setup-gnome-dconf.sh - sets up gnome using dconf

# show minimize button
dconf write /org/gnome/desktop/wm/preferences/button-layout 'appmenu:minimize,close' # show minimize

dconf write /org/gnome/desktop/sound/allow-volume-above-100-percent true
dconf write /org/gnome/mutter/center-new-windows true
dconf write /org/gnome/desktop/input-sources/xkb-options ['caps:hyper'] # caps is hyper
dconf write /org/gnome/desktop/interface/gtk-enable-primary-paste false

# dconf write /org/gnome/desktop/wm/preferences/focus-mode 'sloppy' # focus on hover

# font stuff
dconf write /org/gnome/desktop/interface/font-hinting 'full'
dconf write /org/gnome/desktop/interface/font-antialiasing 'rgba'
dconf write /org/gnome/desktop/interface/font-name 'Noto Sans Medium 11'
dconf write /org/gnome/desktop/interface/document-font-name 'Noto Sans Medium 11'
dconf write /org/gnome/desktop/interface/monospace-font-name 'FiraCode Nerd Font Mono Retina 10'
dconf write /org/gnome/desktop/wm/preferences/titlebar-font 'Noto Sans Medium 11'

dconf write /org/gnome/desktop/interface/color-scheme 'prefer-dark' # dark mode
dconf write /org/gnome/mutter/dynamic-workspaces false # fixed num of workspaces
dconf write /org/gnome/desktop/wm/preferences/num-workspaces 4

dconf write /org/gnome/desktop/session/idle-delay uint32 0 # screen blank time (0 = never)

dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type 'suspend' # suspend on idle
dconf write /org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-timeout 1200 # 20 minutes

dconf write /org/gnome/desktop/peripherals/mouse/accel-profile 'default' # enable mouse accel

dconf write /org/gnome/desktop/peripherals/mouse/speed -0.81611570247933884 # mouse speed

