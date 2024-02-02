#!/usr/bin/env bash
#
# setup.sh - setups up kde settings

# prevent dumb running of the script as it may screw things up
if [[ "$1" != "please" ]]; then
    echo "You didn't say please."
    exit 69
fi

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

[[ -f "kcfg/kcfg.py" ]] || exit 1

# always use the submodule
kcfg() { kcfg/kcfg.py "$@" }

#### THEMING ####
# white cursor is much more visible, i do not need more theming that may break
kcfg 'kcminputrc/Mouse/cursorTheme' --write 'Breeze_Snow'

#### DESKTOP ####
# set window title buttons like so '| icon on_top      minimize maximize close |'
kcfg 'kwinrc/org.kde.kdecoration2/ButtonsOnRight' --delete
kcfg 'kwinrc/org.kde.kdecoration2/ButtonsOnLeft' --write 'MF'

## FONTS ##
kcfg 'kdeglobals/General/fixed' --write 'Hack,11,-1,5,50,0,0,0,0,0'
kcfg 'kdeglobals/General/font' --write 'Noto Sans,11,-1,5,50,0,0,0,0,0'
kcfg 'kdeglobals/General/menuFont' --write 'Noto Sans,11,-1,5,50,0,0,0,0,0'
kcfg 'kdeglobals/General/smallestReadableFont' --write 'Noto Sans,9,-1,5,50,0,0,0,0,0'
kcfg 'kdeglobals/General/toolBarFont' --write 'Noto Sans,11,-1,5,50,0,0,0,0,0'

#### HARDWARE ####
### MICE ###
# for X11, only one global settings is availabel
kcfg 'kcminputrc/Mouse/X11LibInputXAccelProfileFlat' --write false
kcfg 'kcminputrc/Mouse/XLbInptAccelProfileFlat' --write true
kcfg 'kcminputrc/Mouse/XLbInptPointerAcceleration' --write '-0.2'

# for wayland each device can get its own settings
# profile value 1 means flat acceleration profile
## E-Signal USB Gaming Mouse 04D9:A09F ##
kcfg 'kcminputrc/Libinput/1241/41119/E-Signal USB Gaming Mouse/PointerAcceleration' --write '-0.200'
kcfg 'kcminputrc/Libinput/1241/41119/E-Signal USB Gaming Mouse/PointerAccelerationProfile' --write 1

## Logitech, Inc. Unifying Receiver 046D:C534 ##
# this is actually a Logitech M212 mouse from MK240 wireless combo
kcfg 'kcminputrc/Libinput/1133/16418/Logitech Wireless Mouse PID:4022/PointerAcceleration' --write '0.200'
kcfg 'kcminputrc/Libinput/1133/16418/Logitech Wireless Mouse PID:4022/PointerAccelerationProfile' --write 1

### KEYBOARD ###
# make caps into hyper key
kcfg 'kcminputrc/Keyboard/RepeatDelay' --write 400
kcfg 'kxkbrc/Layout/Options' --write 'caps:hyper'

# disable modifier only meta/super/win key shortcut that shows app menu as it
# interferes with any keybinding using hyper as its detected as hyper and super
# pressed in sequence
kcfg 'kwinrc/ModifierOnlyShortcuts/Meta' --write ''


