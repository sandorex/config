#!/usr/bin/env bash
#
# disable-super-keybinding.sh - disables kde keybinding that opens menu

kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""
cat <<EOF
For the change to take affect either logout and login or run following command

$ qdbus org.kde.KWin /KWin reconfigure

EOF

