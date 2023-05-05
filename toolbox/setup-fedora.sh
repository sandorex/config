#!/usr/bin/env bash
#
# fedora-toolbox.sh - setup for toolbox fedora container

# tools i use all the time
TOOLS=(neovim tmux zsh)

# package managers
PKGMAN=(cargo npm)

# other misc packages i need for everything else to work
MISC=(fzf shellcheck)

DNF=(${TOOLS[@]} ${PKGMAN[@]} ${MISC[@]})
CARGO=(bkt)
NPM=()

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
    echo "Installing cargo packages"
    cargo install "${CARGO[@]}"
fi

if [[ "${#NPM[@]}" -ne 0 ]]; then
    echo "Installing npm packages"

    npm install -g "${NPM[@]}"
fi

# TODO define the hostname somehow
# seems this is defined inside the container
#printf "$hostname.toolbox" > sudo tee /etc/hostname

# this is useless as toolbox always runs bash
#if [[ ! "$SHELL" == *zsh ]]; then
#    echo "Setting default shell to zsh"
#    sudo chsh -s /usr/bin/zsh $USER
#fi

# TODO optionally define zerotier and connect to same network defined on host
