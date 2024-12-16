#!/usr/bin/env bash
# buildah container for arcam based on fedora-toolbox

set -euo pipefail

# cd into directory where the script is stored
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

# use dotfiles by default
DOTFILES="$PWD/../dotfiles"
NAME=''
OPTIONS=()

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

CODE_SERVER_VERSION='4.95.3'
CODE_SERVER_URL="https://github.com/coder/code-server/releases/download/v$CODE_SERVER_VERSION/code-server-$CODE_SERVER_VERSION-linux-amd64.tar.gz"

IMAGE_VERSION="40"
IMAGE="registry.fedoraproject.org/fedora-toolbox:$IMAGE_VERSION"

if ! command -v buildah &>/dev/null; then
    echo "buildah was not found.."
    exit 66
fi

POSITIONAL_ARGS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --name)
            NAME="$2"
            shift 2
            ;;

        -o|--option)
            OPTIONS+=("$2")
            shift 2
            ;;

        --dotfiles)
            DOTFILES="$2"
            shift 2
            ;;

        -h|--help)
            cat <<EOF
Usage: $0 [<flags..>]

Flags:
    --name <NAME>       - name of the resulting image (REQUIRED)
    -o / --option <OPT> - enables option in the build
    --dotfiles <DIR>    - override dotfiles path
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

if [[ -z "$NAME" ]]; then
    echo "Image name not set!"
    exit 1
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

ctx="$(buildah from --security-opt label=disable $IMAGE)"

echo "Building image from $IMAGE"

buildah config --label name="arcam-fedora-everything" \
               --label summary="Configurable arcam container image for development" \
               --label maintainer="Sandorex <rzhw3h@gmail.com>" \
               --env LANG='en_US.UTF-8' \
               --env LC_ALL='en_US.UTF-8' \
               --env RUSTUP_HOME=/opt/rustup \
               "$ctx"

# improve DNF speed (although this is not generally recommended picking mirrors for ephimeral container does not make sense)
buildah run "$ctx" sh -c \
    'mkdir -p /init.d "$RUSTUP_HOME"; \
     echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf; \
     echo "defaultyes=True" >> /etc/dnf/dnf.conf; \
     echo "fastestmirror=True" >> /etc/dnf/dnf.conf; \
     echo "install_weak_deps=False" >> /etc/dnf/dnf.conf'

# install rpmfusion
echo
echo "Installing RPMFusion"
buildah run "$ctx" sh -c "dnf -y install 'https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${IMAGE_VERSION:?}.noarch.rpm' \
                       && dnf -y install 'https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${IMAGE_VERSION:?}.noarch.rpm'"

# TODO do caching somehow
# install all dnf stuff
echo
echo "Installing DNF packages: ${DNF[*]}"
buildah run "$ctx" sh -c "dnf -y install ${DNF[*]} && dnf clean all"

# install all npm stuff
if [[ "${#NPM[@]}" -ne 0 ]]; then
    echo
    echo "Installing NPM packages: ${NPM[*]}"
    buildah run "$ctx" sh -c "npm install -g ${NPM[*]} && npm cache clean --force"
fi

# install all pip stuff
if [[ "${#PIP[@]}" -ne 0 ]]; then
    echo
    echo "Installing PIP packages: ${PIP[*]}"
    buildah run "$ctx" sh -c "pip install ${PIP[*]} && pip cache purge"
fi

if [[ " ${OPTIONS[*]} " =~ [[:space:]]code-server[[:space:]] ]]; then
    echo
    echo "Installing code-server version $CODE_SERVER_VERSION"

    buildah run "$ctx" sh -c \
        "curl -fL "$CODE_SERVER_URL" | tar -C /opt/ -xz; \
        ln -s /opt/code-server-$CODE_SERVER_VERSION-linux-amd64/bin/code-server /usr/local/bin/code-server"

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

if [[ " ${OPTIONS[*]} " =~ [[:space:]]code-server[[:space:]] ]]; then
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

if [[ -n "$DOTFILES" ]]; then
    echo
    echo "Copying dotfiles from $DOTFILES"
    buildah run -v "$DOTFILES:/dotfiles:ro" "$ctx" sh -c 'rm -rf /etc/skel && cp -rv /dotfiles/ /etc/skel'
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

# TODO tag with all the tags
buildah commit "$ctx" boxes-fedora-test

echo
echo "Done!"

