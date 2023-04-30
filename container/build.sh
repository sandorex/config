#!/usr/bin/env bash
#
# build.sh - builds podman container

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

set -e

POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        # all arguments are set as variables
        --*)
            var=${1:2} # remove '--'
            var=${var^^} # uppercase
            eval "$var=$2"
            shift 2
            ;;
        *)
            # save positional arg
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# restore positional parameters
set -- "${POSITIONAL_ARGS[@]}"

# currently latest supported version in distrobox is 37
FEDORA_VERSION=${FEDORA_VERSION:-37}
IMAGE=registry.fedoraproject.org/fedora-toolbox:$FEDORA_VERSION

# these are resulting for the resulting image
VERSION=${VERSION:-$FEDORA_VERSION-$(git rev-parse --short=10 HEAD)}
IMAGE_NAME=${IMAGE_NAME:-config-toolbox}

# set zerotier network in pass so it automatically joins
# ZEROTIER=${ZEROTIER:-true}

# configuration to install
CONFIG=wvm.sh

if ! git diff-index --quiet HEAD; then
    VERSION=$VERSION-$(date +%d%m%yT%H%M)
    echo "Beware the config repository is dirty"
    git status --short --untracked-files=no
fi

echo "Building container using image $IMAGE"

# TODO: mount dnf cache somewhere so that it can be reused when rebuilding but
# as optional feature
con=$(buildah from "$IMAGE")

# custom startup script for the container
# buildah config --entrypoint "/config/container/startup.sh" "$con"

# copy whole config directory verbatim
buildah copy "$con" "$PWD/.." "/config"

# TODO it seems fedora-toolbox does not really have a proper user yet...

buildah run -- "$con" /config/container/install_rustup.sh
buildah run -- "$con" /config/container/install_fnm.sh

# TODO test this with cache!
# buildah run -- "$con" dnf -y update \; dnf -y install neovim zsh tmux cargo shellcheck fzf ripgrep \; dnf -y clean all

# run selected config file
# buildah run -- "$con" "/config/configs/$CONFIG"

echo "Saving image as $IMAGE_NAME:$VERSION"
echo "saving is disabled temporarily!"
buildah commit "$con" "$IMAGE_NAME:$VERSION"

