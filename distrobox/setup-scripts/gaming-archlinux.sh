#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# arch container for gaming bootstrap

set -eu

IMAGE="docker.io/library/archlinux:latest"
CONTAINER_NAME="${1:-gaming}"
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

    # editor so i dont have to use vim
    nano

    # for terminal usage
    kitty-terminfo
    wezterm-terminfo
)

if [[ "$1" == "setup" ]] && [[ -v container ]]; then
    echo ":: Generating en_US.UTF8 locale (for game compatibility)"
    sudo sed -i '/^#en_US.UTF-8 UTF-8.*/s/^#//' /etc/locale.gen
    sudo locale-gen

    echo ":: Enabling multilib support"
    cat <<EOF | sudo tee -a /etc/pacman.conf

# ADDED BY SCRIPT $0
[multilib]
Include = /etc/pacman.d/mirrorlist

EOF

    echo ":: Updating the system"
    sudo pacman -Syuu --noconfirm

    echo ":: Installing the packages"
    sudo pacman -S --noconfirm "${PACKAGES[@]}"
else
    if [[ -v container ]]; then
        echo "Running distrobox inside a container is not recommended"
        exit 1
    fi

    echo ":: Creating distrobox container"
    distrobox create --image "$IMAGE" \
                     --name "$CONTAINER_NAME" \
                     --pre-init-hooks "printf '$(uname -n)' >> /etc/hostname" \
                     "${ARGS[@]}"

    echo ":: Starting setup process"
    distrobox enter "$CONTAINER_NAME" -- sh -c "$0 setup"
fi

