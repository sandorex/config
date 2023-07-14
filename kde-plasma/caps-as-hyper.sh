#!/usr/bin/env bash
#
# caps-as-hyper.sh - makes caps lock into the hyper key

kwriteconfig5 --file kxkbrc --group Layout --key Options 'caps:hyper'
echo "It is recommended to disable the modifier shortcut for super as well, as plasma thinks hyper is same as super sometimes"

