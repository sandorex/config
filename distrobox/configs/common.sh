#!/usr/bin/env bash
#
# common.sh - contains common packages for all containers

DNF=(
    "${DNF[@]}"

    # chsh
    util-linux-user

    # tools i use directly
    file
    lsd
    htop
    tmux
    zsh
    qrencode # used for generating qr in console
    hyperfine # benchmarking tool thingy
    ripgrep # regex searching thingy
    bat

    # package managers
    cargo
    golang
    python3-pip
    pipx

    # clipboard support for vim and tmux
    xclip
    wl-clipboard

    # nvim deps
    fzf
    shellcheck

    # other
    unzip
)

UBUNTU_APT=(
    "${UBUNTU_APT[@]}"

    # tools i use directly
    file
    lsd
    htop
    tmux
    zsh
    qrencode # used for generating qr in console
    hyperfine # benchmarking tool thingy
    ripgrep # regex searching thingy
    bat

    # package managers
    cargo
    golang
    python3-pip
    pipx

    # clipboard support for vim and tmux
    xclip
    wl-clipboard

    # nvim deps
    fzf
    shellcheck

    # other
    unzip
)

CARGO=(
    "${CARGO[@]}"

    # does not build for some reason, install in the package manager
    #bat         # cat replacement
    bkt         # caching utility
    bob-nvim    # provides neovim
    fnm         # provides npm/node
    just        # task runner like 'make'
)

NPM=(
    "${NPM[@]}"

    live-server
)

GO=(
    "${GO[@]}"

    'github.com/charmbracelet/gum@latest'   # used by zsh and some scripts
    'github.com/charmbracelet/glow@latest'  # useful markdown cli renderer
)

PIPX=(
    "${PIPX[@]}"

    'yt-dlp' # ytdl fork
)

# these commands will be executable from within the container, commands that
# require root wont work as the container is not priviledged and should not be
DISTROBOX_HOST_EXEC=(
    "${DISTROBOX_HOST_EXEC[@]}"

    flatpak
    podman
    ddcutil # allows changing brightness from within the container
)

