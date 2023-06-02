#!/usr/bin/env bash
#
# setup-kde.sh - sets up kde automagically
#
# very experimental!

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# add the utilities to path temporarily
export PATH="$PWD/kde-plasma-config-util:$PATH"

### THEMING ###
# set dark mode
plasma-apply-colorscheme BreezeDark

# TODO install the cursor theme and set the cursor theme

### LAYOUT ###
# find the first panel by looking for thickness defined
panel=1
for i in $(seq 10); do
    echo "trying panel $i"
    thickness="$(kpcu-read -f "$HOME/.config/plasmashellrc" / 'PlasmaViews' / "Panel $i" / 'Defaults' thickness)"
    if [[ -n "$thickness" ]]; then
        echo "Overwriting panel $i"
        panel="$i"
    fi
done

kpcu-write -f "$HOME/.config/plasmashellrc" / 'PlasmaViews' / "Panel $panel" / 'Defaults' thickness 32
kpcu-write -f "$HOME/.config/plasmashellrc" / 'PlasmaViews' / "Panel $panel" alignment 1
kpcu-write -f "$HOME/.config/plasmashellrc" / 'PlasmaViews' / "Panel $panel" floating 1
kpcu-write -f "$HOME/.config/plasmashellrc" / 'PlasmaViews' / "Panel $panel" panelOpacity 1

# mouse keybindings on desktop
kpcu-write -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" / 'ActionPlugins' / '0' 'MiddleButton;NoModifier' 'org.kde.switchdesktop'
kpcu-write -f "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" / 'ActionPlugins' / '0' 'RightButton;NoModifier' 'org.kde.contextmenu'

### DEVICES ###
# TODO i do not know if these values change between systems, hopefully not
# keyboard repeat rate
kpcu-write -f "$HOME/.config/kcminputrc" / 'Keyboard' RepeatDelay 400
kpcu-write -f "$HOME/.config/kcminputrc" / 'Libinput' / '1241' / '41119' / 'E-Signal USB Gaming Mouse' PointerAcceleration '-0.200'
kpcu-write -f "$HOME/.config/kcminputrc" / 'Libinput' / '1241' / '41119' / 'E-Signal USB Gaming Mouse' PointerAccelerationProfile 1

kpcu-write -f "$HOME/.config/kcminputrc" / 'Libinput' / '1386' / '890' / 'Wacom One by Wacom S Pen' -t bool LeftHanded true
kpcu-write -f "$HOME/.config/kcminputrc" / 'Libinput' / '1386' / '890' / 'Wacom One by Wacom S Pen' OutputArea '0,0,1,1.1041666666666667'
# TODO this depends on the system may require manual setup
# kpcu-write -f "$HOME/.config/kcminputrc" / 'Libinput' / '1386' / '890' / 'Wacom One by Wacom S Pen' OutputName 'HDMI-A-1'

### BEHAVIOUR ###
# TODO desktop only check
kpcu-write -f "$HOME/.config/kscreenlockerrc" / 'Daemon' -t bool Autolock false
kpcu-write -f "$HOME/.config/kscreenlockerrc" / 'Daemon' LockGrace 0
kpcu-write -f "$HOME/.config/kscreenlockerrc" / 'Daemon' -t bool LockOnResume false

# require double click to open things
kpcu-write -f "$HOME/.config/kdeglobals" / 'KDE' SingleClick -t bool false

# show changed values in settings
kpcu-write -f "$HOME/.config/systemsettingsrc" / 'systemsettings_sidebar_mode' -t bool HighlightNonDefaultSettings true

