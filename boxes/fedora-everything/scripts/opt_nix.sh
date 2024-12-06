#!/usr/bin/env bash
# installs nix package manager

set -eux -o pipefail

echo "Installing Nix"
sh <(curl -L https://nixos.org/nix/install) --daemon
cp -n /temp/init/nix.sh /init.d/05-nix.sh

