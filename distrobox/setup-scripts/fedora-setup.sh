#!/usr/bin/env bash
#
# https://github.com/sandorex/config

# this should really speed up dnf
echo "Setting up dnf options to speed it up"
cat <<'EOF' | sudo tee -a /etc/dnf/dnf.conf >/dev/null

# added by fedora-toolbox.sh setup script
max_parallel_downloads=10
defaultyes=True
fastestmirror=True
EOF
echo

if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release &>/dev/null; then
    echo "Installing rpmfusion"
    sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
                        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
    echo
fi
