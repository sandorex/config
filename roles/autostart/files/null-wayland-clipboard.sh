#!/usr/bin/env bash
#
# simply set empty string to wayland clipboard as on old versions it causes problems with some applications like micro editor

set -e
set -o pipefail

printf " " | wl-copy

