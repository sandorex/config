#!/usr/bin/env bash
# installs zig

set -eux -o pipefail

echo "Installing zig"
dnf -y install zig

