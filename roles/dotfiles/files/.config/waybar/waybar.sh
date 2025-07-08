#!/usr/bin/env bash
# script to run waybar properly
#
# this allows all paths inside the config to be relative

# cd in script directory
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

waybar -c config.jsonc
