#!/usr/bin/env bash
# script that installs code-server
# requires curl tar

set -eu

CODE_SERVER_VERSION='4.95.3'
CODE_SERVER_FILENAME="code-server-$CODE_SERVER_VERSION-linux-amd64.tar.gz"
CODE_SERVER_URL="https://github.com/coder/code-server/releases/download/v$CODE_SERVER_VERSION/$CODE_SERVER_FILENAME"

echo
echo "Installing code-server version $CODE_SERVER_VERSION"

# cache the archive
if [[ ! -f "$PWD/$CACHE/$CODE_SERVER_FILENAME" ]]; then
    curl -fL "$CODE_SERVER_URL" --output "$PWD/$CACHE/$CODE_SERVER_FILENAME"
else
    echo "Using cache"
fi

# copy the archive
buildah copy "$ctx" "$PWD/$CACHE/$CODE_SERVER_FILENAME" "/$CODE_SERVER_FILENAME"

# extract it in the container
buildah run "$ctx" sh -c \
    "tar -C /opt -xzf '/$CODE_SERVER_FILENAME' \
  && rm -f '/$CODE_SERVER_FILENAME' \
  && ln -s '/opt/code-server-$CODE_SERVER_VERSION-linux-amd64/bin/code-server' /usr/local/bin/code-server"

# init script that sets up the code-server defaults
buildah run "$ctx" sh -c 'cat > /init.d/80-code-server.sh' <<EOF
#!/usr/bin/env bash

mkdir -p ~/.config/code-server
cat <<eof2 > ~/.config/code-server/config.yaml
app-name: "code-server (${CONTAINER_NAME:-arcam})"
bind-addr: 0.0.0.0:6666
auth: none
cert: false
disable-update-check: true
disable-telemetry: true

eof2
EOF
