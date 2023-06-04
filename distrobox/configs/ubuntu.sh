#!/usr/bin/env bash
#
# ubuntu.sh - config script for container image: ubuntu

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# to set everything up properly
source "../../profile/profile"

cat <<'EOF'
   __  ____                __           _____      __
  / / / / /_  __  ______  / /___  __   / ___/___  / /___  ______
 / / / / __ \/ / / / __ \/ __/ / / /   \__ \/ _ \/ __/ / / / __ \
/ /_/ / /_/ / /_/ / / / / /_/ /_/ /   ___/ /  __/ /_/ /_/ / /_/ /
\____/_.___/\__,_/_/ /_/\__/\__,_/   /____/\___/\__/\__,_/ .___/
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

# TODO i've disabled the additional packages as they are currently fedora only
# # load additional packages
# for i in "$@"; do
#     echo "Loading $i package"
#     source "./packages/$i"
# done
# echo

echo "Installing packages using apt"
sudo apt update
sudo apt install -y "${UBUNTU_APT[@]}"

# do this after as cargo and others may not be installed before
source ./common-post.sh

