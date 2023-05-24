#!/usr/bin/env bash
#
# fedora-toolbox.sh - config script for container image: fedora-toolbox

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# to set everything up properly
source "../../profile/profile"

cat <<'EOF'
    ______         __                    _____      __
   / ____/__  ____/ /___  _________ _   / ___/___  / /___  ______
  / /_  / _ \/ __  / __ \/ ___/ __ `/   \__ \/ _ \/ __/ / / / __ \
 / __/ /  __/ /_/ / /_/ / /  / /_/ /   ___/ /  __/ /_/ /_/ / /_/ /
/_/    \___/\__,_/\____/_/   \__,_/   /____/\___/\__/\__,_/ .___/
                                                         /_/

This may take a while..

EOF

# should only be ran in a container
if [[ -z "$container" ]]; then
    echo "WARNING THIS SCRIPT IS MEANT FOR CONTAINER USE ONLY!"
    exit 1
fi

# get common packages
source ./common.sh

# load additional packages
for i in "$@"; do
    echo "Loading $i package"
    source "./packages/$i"
done
echo

echo "Installing rpmfusion"
sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm \
                    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm
echo

echo "Installing packages using dnf"
sudo dnf -y install "${DNF[@]}"

# do this after as cargo and others may not be installed before
source ./common-post.sh

