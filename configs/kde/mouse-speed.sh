#!/usr/bin/env bash
#
# mouse-speed.sh - sets up kde mouse speed automagically

mouse() {
    kwriteconfig5 --file "$HOME/.config/kcminputrc" \
                  --group 'Libinput' \
                  --group "$1" \
                  --group "$2" \
                  --group "$3" \
                  --key 'PointerAcceleration' "$4"

    kwriteconfig5 --file "$HOME/.config/kcminputrc" \
                  --group 'Libinput' \
                  --group "$1" \
                  --group "$2" \
                  --group "$3" \
                  --key 'PointerAccelerationProfile' "$5"
}

## E-Signal USB Gaming Mouse 04D9:A09F ##
mouse '1241' '41119' 'E-Signal USB Gaming Mouse' 0.200 1
