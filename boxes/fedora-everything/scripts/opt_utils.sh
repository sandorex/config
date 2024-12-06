#!/usr/bin/env bash
# installs utilities

set -eux -o pipefail

echo "Installing utilities"
dnf -y install $(</temp/pkglist/utils-dnf)
npm install -g $(</temp/pkglist/utils-npm)
pip install $(</temp/pkglist/utils-pip)

wget 'https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz'
tar -xvf zellij*.tar.gz
mv zellij /usr/local/bin/zellij

