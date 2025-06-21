#!/usr/bin/env bash
# buildah container for arcam based on fedora-toolbox

set -euo pipefail

# cd into directory where the script is stored
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

REPO='ghcr.io/sandorex'
DOTFILES="$PWD/../../dotfiles"
NAME=''
PUBLISH=0
ALL=0

IMAGE_VERSION="bookworm-slim"
IMAGE="debian:$IMAGE_VERSION"

POSITIONAL_ARGS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --name)
            NAME="$2"
            shift 2
            ;;

        --dotfiles)
            DOTFILES="$2"
            shift 2
            ;;

        --publish)
            PUBLISH=1
            shift
            ;;

        --all)
            ALL=1
            shift
            ;;

        -h|--help)
            cat <<EOF
Usage: $0 [<flags..>]

Flags:
    --name <NAME>       - name of the resulting image (REQUIRED)
    --dotfiles <DIR>    - override dotfiles path
    --publish           - push the image to the repository (requires logged in podman)
    --all               - builds all predefined image templates
    -h / --help         - shows this help text

EOF
            exit 0
            ;;

        -*)
            echo "Unknown option $1"
            exit 1
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

if ! command -v buildah &>/dev/null; then
    echo "buildah was not found.."
    exit 66
fi

if [[ "$ALL" -eq 1 ]]; then
    arg=""
    [[ "$PUBLISH" -eq 1 ]] && arg="--publish"

    ## DEFINE IMAGES HERE !! ##
    "$0" "$arg" --name "arcam-nix"
    ## DEFINE IMAGES HERE !! ##

    # quit early
    exit 0
fi

if [[ -z "$NAME" ]]; then
    echo "Image name not set!"
    exit 1
fi

# try to get the git sha
GIT_SHA=''
if command -v git &>/dev/null; then
    GIT_SHA="$(git rev-parse --short=10 HEAD)"
fi

ctx="$(buildah from --security-opt label=disable "$IMAGE")"
export ctx

echo "Building image '$NAME' from 'debian:$IMAGE_VERSION'"

buildah config --label name="arcam-nix" \
               --label summary="Debian based arcam container image with nix package manager" \
               --label maintainer="Sandorex <rzhw3h@gmail.com>" \
               "$ctx"

echo
echo "Installing Nix package manager"

# install locales, sudo and nix installer dependencies
buildah run "$ctx" sh -c 'apt-get update && apt-get install -y --no-install-recommends sudo bash less xz-utils curl ca-certificates git nano && rm -rf /var/cache/apt/archives /var/lib/apt/lists/*'

# bash is required as <(cmd) is a bashism
buildah run "$ctx" bash -c 'sh <(curl -L https://nixos.org/nix/install) --daemon --yes'

buildah run "$ctx" mkdir /init.d

# daemon is required for nix to work properly
buildah run "$ctx" sh -c 'cat > /init.d/10-nix.sh' <<EOF
#!/usr/bin/env bash
set -euo pipefail

echo "Executing nix-daemon"

# execute daemon and disown it
nohup asroot /nix/var/nix/profiles/default/bin/nix-daemon &> /dev/null &

# if nix is mounted, set it up properly
if findmnt /nix &>/dev/null &>/dev/null; then
    if [ "$(ls -A /nix)"]; then
        # the volume is empty so copy whole store
        asroot cp -ra /nix-builtin/* /nix/
    else
        # volume is not empty so just copy packages
        # login shell so nix is in PATH
        asroot sh -l -c 'nix copy --all --from file:///nix-builtin/store'
    fi
fi

EOF

# enable flakes
buildah run "$ctx" sh -c 'cat > /etc/nix/nix.conf' <<EOF
experimental-features = nix-command flakes

EOF

if [[ -n "$DOTFILES" ]] && [[ -e "$DOTFILES" ]]; then
    echo
    echo "Copying dotfiles from $DOTFILES"
    buildah run -v "$DOTFILES:/dotfiles:ro" "$ctx" sh -c 'rm -rf /etc/skel && cp -r /dotfiles/ /etc/skel'
else
    echo
    echo "Dotfiles not found, skipped.."
fi

# hardlink the builtin so its still accessible even if mounted over
buildah run "$ctx" sh -c 'sudo cp -al /nix /nix-builtin'

# TODO is this required? doesn't arcam chmod automatically?
# make all init files executable at once, reduces boilerplate code above
buildah run "$ctx" sh -c 'chmod +x /init.d/* || :'

# arcam config, stores nix store in a volume
buildah run "$ctx" sh -c 'cat > /config.toml' <<EOF
version = "1"
image = "$REPO/$NAME"
network = true
engine_args = [
    # persist nix store
    "--volume=box-nix:/nix"
]

EOF

buildah run "$ctx" sh -c 'cat > /help.sh; chmod +x /help.sh' <<EOF
#!/bin/sh

cat <<eof
Image made for use with arcam, build date: $(date)

Download from github release:
    https://github.com/sandorex/arcam/releases/latest/download/arcam

Alternatively install it using cargo:
    \$ cargo install arcam

eof
EOF

buildah config --entrypoint /help.sh "$ctx"

buildah commit "$ctx" "$NAME"

# add additional tags
buildah tag "$NAME" "$REPO/$NAME:latest"

# optionally tag with git sha
if [[ -n "$GIT_SHA" ]]; then
    buildah tag "$NAME" "localhost/$NAME:$GIT_SHA"
    buildah tag "$NAME" "$REPO/$NAME:$GIT_SHA"
fi

if [[ "$PUBLISH" -eq 1 ]]; then
    echo
    echo "Publishing image"

    # push git sha tagged
    podman image push "$NAME" "$REPO/$NAME:latest"

    if [[ -n "$GIT_SHA" ]]; then
        podman image push "$NAME" "$REPO/$NAME:$GIT_SHA"
    fi
fi

echo
echo "Done!"
