#!/usr/bin/env bash
# buildah container for arcam based on fedora-toolbox

set -euo pipefail

# cd into directory where the script is stored
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

REPO='ghcr.io/sandorex'
DOTFILES="$PWD/../dotfiles"
NAME=''
OPTIONS=()
DNF_ARGS=(
    # needed as cache is kept on host and reused between containers
    "--setopt" "keepcache=True"
)
PUBLISH=0
ALL=0

DNF=(
    git
    just
    curl
    wget
    zsh
    nano
    neovim
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

IMAGE_VERSION="40"
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

    "$0" "$arg" --name arcam-f40-mini
    "$0" "$arg" --name arcam-f40 -- utils
    "$0" "$arg" --name arcam-f40-code -- utils code-server

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

if [[ " ${OPTIONS[*]} " =~ [[:space:]]utils[[:space:]] ]]; then
    DNF+=( "${UTILS_DNF[@]}" )
    NPM+=( "${UTILS_NPM[@]}" )
    PIP+=( "${UTILS_PIP[@]}" )
fi

if [[ "${#NPM[@]}" -ne 0 ]]; then
    DNF+=( 'npm' )
fi

if [[ "${#PIP[@]}" -ne 0 ]]; then
    DNF+=( 'python3-pip' )
fi

ctx="$(buildah from --security-opt label=disable "$IMAGE")"

# create cache dirs
mkdir -p "$PWD/dnf-cache" "$PWD/npm-cache" "$PWD/pip-cache"

echo "Building image '$NAME' from 'fedora-toolbox:$IMAGE_VERSION' using options '${OPTIONS[*]}'"

buildah config --label name="arcam-fedora-everything" \
               --label summary="Configurable arcam container image for development" \
               --label maintainer="Sandorex <rzhw3h@gmail.com>" \
               --env LANG='en_US.UTF-8' \
               --env LC_ALL='en_US.UTF-8' \
               --env RUSTUP_HOME=/opt/rustup \
               "$ctx"

# improve DNF speed
buildah run "$ctx" sh -c \
    'mkdir -p /init.d "$RUSTUP_HOME"; \
     echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf; \
     echo "defaultyes=True" >> /etc/dnf/dnf.conf; \
     echo "install_weak_deps=False" >> /etc/dnf/dnf.conf'

# install rpmfusion
echo
echo "Installing RPMFusion"
buildah run -v "$PWD/dnf-cache:/var/cache/dnf" "$ctx" sh -c \
        "dnf ${DNF_ARGS[*]} -y install 'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$IMAGE_VERSION.noarch.rpm' \
      && dnf ${DNF_ARGS[*]} -y install 'https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$IMAGE_VERSION.noarch.rpm'"

# install all dnf stuff
echo
echo "Installing DNF packages: ${DNF[*]}"
buildah run -v "$PWD/dnf-cache:/var/cache/dnf" "$ctx" sh -c \
        "dnf ${DNF_ARGS[*]} -y install ${DNF[*]}"

# install all npm stuff
if [[ "${#NPM[@]}" -ne 0 ]]; then
    echo
    echo "Installing NPM packages: ${NPM[*]}"
    buildah run -v "$PWD/npm-cache:/root/.npm" "$ctx" sh -c "npm install -g ${NPM[*]}"
fi

# install all pip stuff
if [[ "${#PIP[@]}" -ne 0 ]]; then
    echo
    echo "Installing PIP packages: ${PIP[*]}"
    buildah run -v "$PWD/pip-cache:/root/.cache/pip" "$ctx" sh -c "pip install ${PIP[*]}"
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]code-server[[:space:]] ]]; then
    CODE_SERVER_VERSION='4.95.3'
    CODE_SERVER_URL="https://github.com/coder/code-server/releases/download/v$CODE_SERVER_VERSION/code-server-$CODE_SERVER_VERSION-linux-amd64.tar.gz"

    echo
    echo "Installing code-server version $CODE_SERVER_VERSION"

    buildah run "$ctx" sh -c \
        "curl -fL '$CODE_SERVER_URL' | tar -C /opt/ -xz; \
        ln -s '/opt/code-server-$CODE_SERVER_VERSION-linux-amd64/bin/code-server' /usr/local/bin/code-server"

    # init script that sets up the code-server defaults
    buildah run "$ctx" sh -c 'cat > /init.d/80-code-server.sh' <<EOF
#!/usr/bin/env bash

mkdir -p ~/.config/code-server
cat <<eof2 > ~/.config/code-server/config.yaml
app-name: "code-server (${CONTAINER_NAME:-arcam})"
bind-addr: 0.0.0.0:6666
auth: none
cert: false
disable-update-check: true
disable-telemetry: true

eof2
EOF
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]nix[[:space:]] ]]; then
    echo
    echo "Installing nix package manager"

    buildah run "$ctx" sh -c 'sh <(curl -L https://nixos.org/nix/install) --daemon'

    buildah run "$ctx" sh -c 'cat > /help.sh; chmod +x /help.sh' <<EOF
#!/usr/bin/env bash
# execute nix daemon on startup

echo "Executing nix-daemon"
nohup sudo /nix/var/nix/profiles/default/bin/nix-daemon &> /dev/null &
EOF
fi

if [[ -n "$DOTFILES" ]] && [[ -e "$DOTFILES" ]]; then
    echo
    echo "Copying dotfiles from $DOTFILES"
    buildah run -v "$DOTFILES:/dotfiles:ro" "$ctx" sh -c 'rm -rf /etc/skel && cp -r /dotfiles/ /etc/skel'
fi

# make all init files executable at once, reduces boilerplate code above
buildah run "$ctx" sh -c 'chmod +x /init.d/* || :'

# disable zsh newuser prompt thingy
buildah run "$ctx" sh -c 'echo "zsh-newuser-install() {}" >> /etc/zshenv'

buildah run "$ctx" sh -c 'cat > /usr/local/bin/bootstrap-nvim; chmod +x /usr/local/bin/bootstrap-nvim' <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

# if the directory is empty, bootstrap neovim
if [[ ! -d ~/.local/share/nvim ]] || [[ -z "$(ls -A ~/.local/share/nvim)" ]]; then
    echo "Bootstrapping neovim"
    nvim --headless +Bootstrap +q
else
    echo "Neovim already bootstrapped"
fi
EOF

buildah run "$ctx" sh -c 'cat > /usr/local/bin/bootstrap-rust; chmod +x /usr/local/bin/bootstrap-rust' <<'EOF'
#!/usr/bin/env bash
echo "Installing stable rust toolchain with LSP extras"

sudo chown $USER:$USER /opt/rustup

# rust-analyzer and rust-src are needed for LSP
rustup-init -y \
    --no-modify-path \
    --default-toolchain stable \
    -c clippy \
    -c rust-analyzer \
    -c rust-src

EOF

buildah run "$ctx" sh -c 'cat > /help.sh; chmod +x /help.sh' <<EOF
#!/bin/sh

cat <<eof
Image made for use with arcam

The image has following options enabled: ${OPTIONS[*]}

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
