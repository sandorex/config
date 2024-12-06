#!/usr/bin/env bash
# installs utilities

set -eux -o pipefail

echo "Installing utilities"
dnf -y install $(</temp/pkglist/utils-dnf)
npm install -g $(</temp/pkglist/utils-npm)
pip install $(</temp/pkglist/utils-pip)

