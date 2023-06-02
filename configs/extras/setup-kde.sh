#!/usr/bin/env bash
#
# setup-kde.sh - sets up kde automagically
#
# very experimental!

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

F_PLASMASHELLRC="$HOME/.config/plasmashellrc"
F_APPLETSRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
F_KCMINPUTRC="$HOME/.config/kcminputrc"
F_KSCREENLOCKRC="$HOME/.config/kscreenlockerrc"
F_SYSTEMSETTINGSRC="$HOME/.config/systemsettingsrc"

kpcu-write() {
    ARGS=( "$@" )
    KEY="${ARGS[-2]}"
    VALUE="${ARGS[-1]}"
    ARGS=( "${ARGS[@]:0:$(( ${#ARGS[@]} - 2 ))}" )
    ARGS=( "${ARGS[@]/#/--group }" )

    if [[ -n "$FILE" ]]; then
        ARGS=( '--file' "$FILE" "${ARGS[@]}" )
    fi

    # even though i have not seen a reason to write bools as strings but eh
    if [[ "$VALUE" == ":true" ]] || [[ "$VALUE" == ":false" ]]; then
        ARGS+=( '--type' 'bool' )
        VALUE=${VALUE:1}
    fi

    kwriteconfig5 "${ARGS[@]}" --key "$KEY" "$VALUE"
}

kpcu-del() {
    ARGS=( "$@" )
    KEY="${ARGS[-1]}"
    ARGS=( "${ARGS[@]:0:$(( ${#ARGS[@]} - 1 ))}" )
    ARGS=( "${ARGS[@]/#/--group }" )

    if [[ -n "$FILE" ]]; then
        ARGS=( '--file' "$FILE" "${ARGS[@]}" )
    fi

    kwriteconfig5 "${ARGS[@]}" --delete --key "$KEY"
}

kpcu-read() {
    ARGS=( "$@" )
    KEY="${ARGS[-1]}"
    ARGS=( "${ARGS[@]:0:$(( ${#ARGS[@]} - 1 ))}" )
    ARGS=( "${ARGS[@]/#/--group }" )

    if [[ -n "$FILE" ]]; then
        ARGS=( '--file' "$FILE" "${ARGS[@]}" )
    fi

    kreadconfig5 "${ARGS[@]}" --key "$KEY"
}

### THEMING ###
# set dark mode
plasma-apply-colorscheme BreezeDark

# install cursor theme from git
TMPDIR="$(mktemp)"
pushd "$TMPDIR"
git clone https://github.com/sandorex/Layan-cursors.git cursors
cd cursors
./install.sh &>/dev/null
popd

# apply the cursor theme
plasma-apply-cursortheme Layan-border-cursors

### LAYOUT ###
FILE="$F_APPLETSRC"

# find the first panel by looking for thickness defined
panel=1
for i in $(seq 10); do
    thickness="$(kpcu-read 'PlasmaViews' "Panel $i" 'Defaults' thickness)"
    if [[ -n "$thickness" ]]; then
        echo "Overwriting panel $i"
        panel="$i"

        break
    fi
done

# get all indexes of applets
applets_order=$(kpcu-read 'Containments' "$panel" 'General' AppletOrder)
mapfile -t applets < <(echo "$applets_order" | tr ';' ' ')
unset applets_order

if [[ "${#applets[@]}" -eq 0 ]]; then
    echo
    echo "Something's wrong i can feel it, applet order not found"
    exit 1
fi

for i in "${applets[@]}"; do
    plugin=$(kpcu-read 'Containments' "$panel" 'General' Plugin)
    case "$plugin" in
        org.kde.plasma.kickoff|org.kde.plasma.kickerdash)
            # replace the launcher with kicker
            kpcu-write 'Containments' "$panel" 'General' Plugin 'org.kde.plasma.kicker'
            ;;
        org.kde.plasma.icontasks)
            # TODO i believe its the option to show all windows when clicking on group of windows
            kpcu-write 'Containments' "$panel" 'Applets' "$i" 'Configuration' 'General' groupedTaskVisualization 1

            # set the pinned launchers
            kpcu-write 'Containments' "$panel" 'Applets' "$i" 'Configuration' 'General' launchers 'preferred://filemanager,applications:org.mozilla.firefox.desktop,applications:org.wezfurlong.wezterm.desktop'
            ;;
        org.kde.plasma.digitalclock)
            # hide date and show 24h clock
            kpcu-write 'Containments' "$panel" 'Applets' "$i" 'Configuration' 'Appearance' showDate :false
            kpcu-write 'Containments' "$panel" 'Applets' "$i" 'Configuration' 'Appearance' use24hFormat 2
            ;;
        *)
            echo "Cannot configure plugin '$plugin', skipping.."
            continue
            ;;
    esac
done

# mouse keybindings on desktop
kpcu-write 'ActionPlugins' '0' 'MiddleButton;NoModifier' 'org.kde.switchdesktop'
kpcu-write 'ActionPlugins' '0' 'RightButton;NoModifier' 'org.kde.contextmenu'

FILE="$F_PLASMASHELLRC"
kpcu-write 'PlasmaViews' "Panel $panel" 'Defaults' thickness 32
kpcu-write 'PlasmaViews' "Panel $panel" alignment 1
kpcu-write 'PlasmaViews' "Panel $panel" floating 1
kpcu-write 'PlasmaViews' "Panel $panel" panelOpacity 1

### DEVICES ###
FILE="$F_KCMINPUTRC"
# TODO i do not know if these values change between systems, hopefully not
# keyboard repeat rate
kpcu-write 'Keyboard' RepeatDelay 400

# TODO All of these is for desktop only
kpcu-write 'Libinput' '1241' '41119' 'E-Signal USB Gaming Mouse' PointerAcceleration '-0.200'
kpcu-write 'Libinput' '1241' '41119' 'E-Signal USB Gaming Mouse' PointerAccelerationProfile 1

kpcu-write 'Libinput' '1386' '890' 'Wacom One by Wacom S Pen' LeftHanded :true
kpcu-write 'Libinput' '1386' '890' 'Wacom One by Wacom S Pen' OutputArea '0,0,1,1.1041666666666667'
# TODO this depends on the system may require manual setup
# kpcu-write 'Libinput' '1386' '890' 'Wacom One by Wacom S Pen' OutputName 'HDMI-A-1'

### BEHAVIOUR ###
FILE="$F_KSCREENLOCKRC"
# TODO this should only be done on desktop
# disables auto locking cause its annoying and useless on a desktop
kpcu-write 'Daemon' Autolock :false
kpcu-write 'Daemon' LockGrace 0
kpcu-write 'Daemon' LockOnResume :false

# require double click to open things
FILE='' kpcu-write 'KDE' SingleClick :false

# show changed values in settings
FILE="$F_SYSTEMSETTINGSRC" kpcu-write 'systemsettings_sidebar_mode' HighlightNonDefaultSettings true

