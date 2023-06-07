#!/usr/bin/env/bash
#
# install-common.sh - installs packages added in the arrays

if [[ "${#CARGO[@]}" -ne 0 ]]; then
    echo
    echo "Installing cargo packages"
    cargo install "${CARGO[@]}"
fi

# setup fnm if not already setup
[[ -z "$FNM_DIR" ]] && eval "$(fnm env)"
fnm use --install-if-missing lts-latest

# install yarn via corepack
corepack enable
corepack prepare yarn@stable --activate

# disable telemetry
yarn config set --home enableTelemetry 0

# custom home for npm
npm config set prefix "$NPM_HOME"

# yarn does not seem to support packages so install using npm
if [[ "${#NPM[@]}" -ne 0 ]]; then
    echo
    echo "Installing npm packages"

    npm install -g "${NPM[@]}"
fi

if [[ "${#GO[@]}" -ne 0 ]]; then
    echo
    echo "Installing golang packages"

    if [[ -z "$GOPATH" ]]; then
        echo "Skipped as \$GOPATH is not defined!"
    else
        go install "${GO[@]}"
    fi
fi

if [[ "${#PIP[@]}" -ne 0 ]]; then
    echo
    echo "Installing pip packages"

    python3 -m pip install --user "${PIP[@]}"
fi

if [[ -n "$DISTROBOX_ENTER_PATH" ]] && [[ "${#DISTROBOX_HOST_EXEC[@]}" -ne 0 ]]; then
    echo
    echo "Making distrobox-host-exec symlinks"

    for i in "${DISTROBOX_HOST_EXEC[@]}"; do
        sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/"$i"
    done
fi

echo
echo "Installing latest stable neovim"
bob use stable

