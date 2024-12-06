#!/usr/bin/env bash
# installs rustup

set -eux -o pipefail

echo "Installing rustup"
mkdir -p $RUSTUP_HOME
cp -n /temp/init/rustup.sh /init.d/20-rustup.sh

