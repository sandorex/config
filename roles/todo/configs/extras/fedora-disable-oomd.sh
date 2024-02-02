#!/usr/bin/env bash
#
# fedora-disable-oomd.sh - disable oomd service that causes problems

# kill it with fire

sudo systemctl stop systemd-oomd.service
sudo systemctl disable systemd-oomd.service
sudo systemctl mask systemd-oomd.service

