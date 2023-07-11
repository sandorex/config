#!/usr/bin/env bash
#
# keyboard.sh - sets up kde keyboard automagically

kwriteconfig5 --file "$HOME/.config/kcminputrc" \
              --group 'Keyboard' \
              --key 'RepeatDelay' 400

# make caps an additional escape
kwriteconfig5 --file "$HOME/.config/kxkbrc" \
              --group 'Layout' \
              --key 'Options' caps:escape
