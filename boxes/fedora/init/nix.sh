#!/usr/bin/env bash
# execute nix daemon on startup

echo "Executing nix-daemon"
nohup sudo /nix/var/nix/profiles/default/bin/nix-daemon &> /dev/null &
