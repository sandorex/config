#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# arch container for gaming bootstrap

set -e

IMAGE="docker.io/library/archlinux:latest"
CONTAINER_NAME="${1:-arch}"
PACKAGES=(
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
    echo ":: Generating en_US.UTF8 locale"
    sudo sed -i '/^#en_US.UTF-8 UTF-8.*/s/^#//' /etc/locale.gen
    sudo locale-gen

    echo ":: Updating the container"
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

