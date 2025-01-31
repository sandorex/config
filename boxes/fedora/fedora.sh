#!/usr/bin/env bash
# buildah container for arcam based on fedora-toolbox

set -euo pipefail

# cd into directory where the script is stored
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

REPO='ghcr.io/sandorex'
DOTFILES="$PWD/../../dotfiles"
NAME=''
OPTIONS=()
DNF_ARGS=(
    # needed as cache is kept on host and reused between containers
    "--setopt" "keepcache=True"
)
PUBLISH=0
ALL=0

export CACHE="cache"
DNF_CACHE="$CACHE/dnf"
NPM_CACHE="$CACHE/npm"
PIP_CACHE="$CACHE/pip"

DNF=(
    git
    just
    curl
    wget
    fish
    nano
    neovim
    emacs-nox
    glibc-langpack-en
)

NPM=()
PIP=()

UTILS_DNF=(
    gitui
    lsd
    bat
    perl
    rustup
    shellcheck
)

UTILS_NPM=(
    typescript-language-server
    typescript
    vscode-langservers-extracted
    bash-language-server
    live-server
)

UTILS_PIP=(
    python-lsp-server
    neovim
    jedi-language-server
    cmake-language-server
    git-cliff
)

IMAGE_VERSION="41"
IMAGE="registry.fedoraproject.org/fedora-toolbox:$IMAGE_VERSION"

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

        --)
            # consume all the rest as options
            shift
            OPTIONS+=("$@")
            break
            ;;

        -h|--help)
            cat <<EOF
Usage: $0 [<flags..>] [-- <options..>]

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

    "$0" "$arg" --name "arcam-fedora-full" -- all
    "$0" "$arg" --name "arcam-fedora-mini"
    "$0" "$arg" --name "arcam-fedora-nix" -- nix
    "$0" "$arg" --name "arcam-fedora" -- utils zig

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

if [[ " ${OPTIONS[*]} " =~ [[:space:]]utils[[:space:]] || "${OPTIONS[*]}" == "all" ]]; then
    DNF+=( "${UTILS_DNF[@]}" )
    NPM+=( "${UTILS_NPM[@]}" )
    PIP+=( "${UTILS_PIP[@]}" )
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]zig[[:space:]] || "${OPTIONS[*]}" == "all" ]]; then
    DNF+=( "zig" )
fi

if [[ "${#NPM[@]}" -ne 0 ]]; then
    DNF+=( 'npm' )
fi

if [[ "${#PIP[@]}" -ne 0 ]]; then
    DNF+=( 'python3-pip' )
fi

export ctx="$(buildah from --security-opt label=disable "$IMAGE")"

# create cache dirs
mkdir -p "$PWD/$CACHE" "$PWD/$DNF_CACHE" "$PWD/$NPM_CACHE" "$PWD/$PIP_CACHE"

echo "Building image '$NAME' from 'fedora-toolbox:$IMAGE_VERSION' using options '${OPTIONS[*]}'"

buildah config --label name="arcam-fedora-everything" \
               --label summary="Configurable arcam container image for development" \
               --label maintainer="Sandorex <rzhw3h@gmail.com>" \
               --env LANG='en_US.UTF-8' \
               --env LC_ALL='en_US.UTF-8' \
               --env RUSTUP_HOME=/opt/rustup \
               "$ctx"

# improve DNF speed
# shellcheck disable=SC2016
buildah run "$ctx" sh -c \
    'mkdir -p /init.d "$RUSTUP_HOME"; \
     echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf; \
     echo "defaultyes=True" >> /etc/dnf/dnf.conf; \
     echo "install_weak_deps=False" >> /etc/dnf/dnf.conf'

# install rpmfusion
echo
echo "Installing RPMFusion"
buildah run -v "$PWD/$DNF_CACHE:/var/cache/dnf" "$ctx" -- dnf "${DNF_ARGS[@]}" -y install \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$IMAGE_VERSION.noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$IMAGE_VERSION.noarch.rpm"

# install all dnf stuff
echo
echo "Installing DNF packages: ${DNF[*]}"
buildah run -v "$PWD/$DNF_CACHE:/var/cache/dnf" "$ctx" -- dnf "${DNF_ARGS[@]}" -y install "${DNF[@]}"

# install all npm stuff
if [[ "${#NPM[@]}" -ne 0 ]]; then
    echo
    echo "Installing NPM packages: ${NPM[*]}"
    buildah run -v "$PWD/$NPM_CACHE:/root/.npm" "$ctx" -- npm install -g "${NPM[@]}"
fi

# install all pip stuff
if [[ "${#PIP[@]}" -ne 0 ]]; then
    echo
    echo "Installing PIP packages: ${PIP[*]}"
    buildah run -v "$PWD/$PIP_CACHE:/root/.cache/pip" "$ctx" -- pip install "${PIP[@]}"
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]code-server[[:space:]] || "${OPTIONS[*]}" == "all"  ]]; then
    ./scripts/code-server.sh
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]nix[[:space:]] || "${OPTIONS[*]}" == "all"  ]]; then
    ./scripts/nix.sh
fi

if [[ -n "$DOTFILES" ]] && [[ -e "$DOTFILES" ]]; then
    echo
    echo "Copying dotfiles from $DOTFILES"
    buildah run -v "$DOTFILES:/dotfiles:ro" "$ctx" sh -c 'rm -rf /etc/skel && cp -r /dotfiles/ /etc/skel'
else
    echo
    echo "Dotfiles not found, skipped.."
fi

./scripts/nvim.sh

# make all init files executable at once, reduces boilerplate code above
buildah run "$ctx" sh -c 'chmod +x /init.d/* || :'

# disable zsh newuser prompt thingy
buildah run "$ctx" sh -c 'echo "zsh-newuser-install() {}" >> /etc/zshenv'

./scripts/rustup.sh

# TODO add zig cache to volumes
# this is the arcam config, currently does not need to change between options
buildah run "$ctx" sh -c 'cat > /config.toml' <<EOF
[[config]]
name = "$NAME"
image = "$REPO/$NAME"
network = true
engine_args_podman = [
    # persist neovim plugins
    "--volume=box-nvim:\$HOME/.local/share/nvim",

    # persist cargo packages
    "--volume=box-cargo:\$HOME/.cargo/registry",

    # persist rustup toolchains
    "--volume=box-rustup:/opt/rustup",
]
on_init_pre = [
    # all volumes are owned by root by default
    "sudo chown \$USER:\$USER ~/.local/share/nvim ~/.cargo ~/.cargo/registry",
]

[config.env]
# force neovim to use terminal to read/write clipboard
"NVIM_FORCE_OSC52" = "true"

EOF

buildah run "$ctx" sh -c 'cat > /help.sh; chmod +x /help.sh' <<EOF
#!/bin/sh

cat <<eof
Image made for use with arcam, build date: $(date)

The image has following options enabled: ${OPTIONS[*]}

Download from github release:
    https://github.com/sandorex/arcam/releases/latest/download/arcam

Alternatively install it using cargo:
    \$ cargo install arcam

eof
EOF

buildah config --entrypoint /help.sh "$ctx"

buildah commit --squash "$ctx" "$NAME"

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
