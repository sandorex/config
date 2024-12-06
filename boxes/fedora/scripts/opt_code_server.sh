#!/usr/bin/env bash
# installs code-server

set -eux -o pipefail

VERSION='4.95.3'
URL="https://github.com/coder/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-amd64.tar.gz"

echo "Installing option CODE_SERVER"
curl -fL "$URL" | tar -C /opt/ -xz
ln -s /opt/code-server-$VERSION-linux-amd64/bin/code-server /usr/local/bin/code-server

