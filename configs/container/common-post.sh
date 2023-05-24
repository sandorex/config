#!/usr/bin/env/bash
#
# install-common.sh - installs packages added in the arrays

if [[ "${#CARGO[@]}" -ne 0 ]]; then
    echo
    echo "Installing cargo packages"
    cargo install "${CARGO[@]}"
fi

# TODO
eval "$(fnm env)"
fnm use --install-if-missing lts-latest

npm config set prefix "$NPM_HOME"

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

if command -v distrobox-host-exec &>/dev/null && [[ "${#HOST_EXEC[@]}" -ne 0 ]]; then
    echo
    echo "Making distrobox-host-exec symlinks"

    for i in "${HOST_EXEC[@]}"; do
        sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/"$i"
    done
fi

echo
echo "Installing latest stable neovim"
bob use stable

