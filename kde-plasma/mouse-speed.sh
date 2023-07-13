#!/usr/bin/env bash
#
# mouse-speed.sh - sets up kde mouse speed automagically

echo "this does not work yet, kwriteconfig5 is broken and cannot do the only fucking thing it was supposed to and that is write a config as string so i cannot set a negative number like '-0.200'"
exit 1

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
mouse '1241' '41119' 'E-Signal USB Gaming Mouse' ' -0.200' 1
