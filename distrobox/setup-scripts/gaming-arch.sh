#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# arch container for gaming bootstrap
#
# container must be in different home as steam saves things in ~/.steam

set -e

IMAGE="docker.io/library/archlinux:latest"
ASDF_BRANCH="v0.14.0"
PROTON_GE_VERSIONS=( latest )
PACKAGES=(
    vulkan-radeon
    lib32-vulkan-radeon
    #amdvlk # i do not know if this is needed
    ttf-liberation # used by steam to replace ariel font
    gamemode # might slightly boost performance
    steam

    # i think this is not needed anymore as steam has its own UI for this now
    # file chooser portal, cannot add non-steam games without it
    #xdg-desktop-portal
    #xdg-desktop-portal-kde

    # core utils
    perl
    coreutils

    # for asdf
    curl
    git

    # editor so i dont have to use vim
    nano

    # for terminal usage
    kitty-terminfo
    wezterm-terminfo
)

if [[ "$1" == "setup" ]] && [[ -v container ]]; then
    echo ":: Generating en_US.UTF8 locale"
    sudo sed -i '/^#en_US.UTF-8 UTF-8.*/s/^#//' /etc/locale.gen
    sudo locale-gen

    echo ":: Enabling multilib support"
    cat <<EOF | sudo tee -a /etc/pacman.conf

# ADDED BY SCRIPT $0
[multilib]
Include = /etc/pacman.d/mirrorlist

EOF

    echo ":: Updating the container"
    sudo pacman -Syuu --noconfirm

    echo ":: Installing the packages"
    sudo pacman -S --noconfirm "${PACKAGES[@]}"

    echo ":: Installing asdf version manager"
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$ASDF_BRANCH"

    echo ":: Adding asdf to shell init files"
    cat <<EOF | tee -a ~/.zshrc ~/.bashrc
# load asdf (added by $0)
. "$HOME/.asdf/asdf.sh"
EOF

    echo ":: Installing proton-ge using asdf"
    asdf plugin add protonge

    for i in "${PROTON_GE_VERSIONS[@]}"; do
        asdf install protonge "$i"
    done

    echo ":: Exporting Steam to host"
    distrobox-export --app Steam

    echo ":: Container setup finished"
else
    if [[ -v container ]]; then
        echo "Running distrobox inside a container is not recommended"
        exit 1
    fi

    if [[ "$#" -lt 2 ]]; then
        echo "Usage: $0 <container_name> <container_home>"
        exit 1
    fi

    CONTAINER_NAME="$1"
    CONTAINER_HOME="$2"

    echo ":: Creating distrobox container"
    distrobox create --image "$IMAGE" \
                     --name "$CONTAINER_NAME" \
                     --home "$CONTAINER_HOME" \
                     --pre-init-hooks "cat /run/host/etc/hostname > /etc/hostname" \
                     "${ARGS[@]}"

    echo ":: Starting setup process"
    distrobox enter "$CONTAINER_NAME" -- sh -c "$0 setup"
fi

