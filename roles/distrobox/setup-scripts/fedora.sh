#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# fedora container bootstrap

set -e

IMAGE="registry.fedoraproject.org/fedora-toolbox:39"
CONTAINER_NAME="${CONTAINER_NAME:-fedora}"
PACKAGES=(
    kitty-terminfo
)

if [[ "$1" == "setup" ]] && [[ -v container ]]; then
    # this should really speed up dnf
    echo ":: Configuring DNF5 options"
    cat <<EOF | sudo tee -a /etc/dnf/dnf.conf >/dev/null

# added by $0 setup script
max_parallel_downloads=10
defaultyes=True
fastestmirror=True
EOF

    if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release &>/dev/null; then
        echo ":: Installing rpmfusion"
        sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
                            https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
        echo
    fi

    echo ":: Updating the container"
    sudo dnf -y update

    if [[ "${#PACKAGES[@]}" -gt 0 ]]; then
        echo ":: Installing configured packages"
        sudo dnf -y install "${PACKAGES[@]}"
    fi
else
    if [[ -v container ]]; then
        echo "Running distrobox inside a container is not recommended"
        exit 1
    fi

    echo ":: Creating distrobox container"
    distrobox create --image "$IMAGE" \
                     --name "$CONTAINER_NAME" \
                     --pre-init-hooks "cat /run/host/etc/hostname > /etc/hostname" \
                     "$@"

    echo ":: Starting setup process"
    distrobox enter "$CONTAINER_NAME" -- sh -c "$0 setup"
fi

