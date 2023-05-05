#!/usr/bin/env bash
#
# fedora-toolbox.sh - setup for toolbox fedora container

# tools i use all the time
TOOLS=( tmux zsh )

# package managers
PKGMAN=( cargo npm go )

# other misc packages i need for everything else to work
MISC=( fzf shellcheck )

DNF=("${TOOLS[@]}" "${PKGMAN[@]}" "${MISC[@]}")
CARGO=( bkt bob-nvim )
NPM=()
GO=( 'github.com/charmbracelet/gum@latest' )

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

echo "Installing packages using dnf"
sudo dnf -y install "${DNF[@]}"

if [[ "${#CARGO[@]}" -ne 0 ]]; then
    echo
    echo "Installing cargo packages"
    cargo install "${CARGO[@]}"
fi

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
    fi

    go install "${GO[@]}"
fi

echo
echo "Installing latest stable neovim"
bob use stable

