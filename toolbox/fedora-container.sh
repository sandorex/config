#!/usr/bin/env bash
#
# fedora-toolbox.sh - setup for toolbox fedora container

DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")

# to set everything up properly
source "$DIR/../profile/profile"

# base minimal packages
DNF=(
    # tools i use directly
    file
    tmux
    zsh
    qrencode # used for generating qr in console
    hyperfine # benchmarking tool thingy
    ripgrep # regex searching thingy

    # package managers
    cargo
    npm
    go
    python3-pip

    # clipboard support for vim and tmux
    xclip
    wl-clipboard

    # nvim deps
    fzf
    shellcheck
)

CARGO=(
    bat # cat replacement
    bkt # used by tmux
    bob-nvim # provides neovim
)
NPM=(
    live-server
)
GO=(
    'github.com/charmbracelet/gum@latest' # used by zsh and some scripts
    'github.com/charmbracelet/glow@latest' # useful markdown cli renderer
)
PIP=()
HOST_EXEC=(
    # these executables will be available inside the distrobox container
    # allow managing the silverblue inside the container
    rpm-ostree
    # ostree # this is a rootless container so cant run many ostree commands

    flatpak
    podman
)

cat <<'EOF'
  ______            ____
 /_  __/___  ____  / / /_  ____  _  __
  / / / __ \/ __ \/ / __ \/ __ \| |/_/
 / / / /_/ / /_/ / / /_/ / /_/ />  <
/_/  \____/\____/_/_.___/\____/_/|_|


Setting up toolbox
This may take a while..

EOF

if [[ ! "$container" == "oci" ]]; then
    echo "WARNING THIS SCRIPT IS MEANT FOR CONTAINER USE ONLY!"
    exit 1
fi

# load additional packages
for i in "$@"; do
    echo "Loading $i package"
    source "$DIR/packages/$i"
done
echo

echo "Installing rpmfusion"
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
echo

echo "Installing packages using dnf"
sudo dnf -y install "${DNF[@]}"

if [[ "${#CARGO[@]}" -ne 0 ]]; then
    echo
    echo "Installing cargo packages"
    cargo install "${CARGO[@]}"
fi

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

echo
echo "Installing latest stable neovim"
bob use stable

if command -v distrobox-host-exec &>/dev/null && [[ "${#HOST_EXEC[@]}" -ne 0 ]]; then
    echo
    echo "Making distrobox-host-exec symlinks"

    for i in "${HOST_EXEC[@]}"; do
        sudo ln -sf /usr/bin/distrobox-host-exec /usr/local/bin/"$i"
    done
fi
