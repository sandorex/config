#!/usr/bin/env bash
#
# common.sh - contains common packages for all containers

DNF=(
    "${DNF[@]}"

    # tools i use directly
    file
    tmux
    zsh
    qrencode # used for generating qr in console
    hyperfine # benchmarking tool thingy
    ripgrep # regex searching thingy

    # package managers
    cargo
    golang
    python3-pip

    # clipboard support for vim and tmux
    xclip
    wl-clipboard

    # nvim deps
    fzf
    shellcheck
)

UBUNTU_APT=(
    "${UBUNTU_APT[@]}"

    # tools i use directly
    file
    tmux
    zsh
    qrencode # used for generating qr in console
    hyperfine # benchmarking tool thingy
    ripgrep # regex searching thingy

    # package managers
    cargo
    golang
    python3-pip

    # clipboard support for vim and tmux
    xclip
    wl-clipboard

    # nvim deps
    fzf
    shellcheck
)

CARGO=(
    "${CARGO[@]}"

    bat         # cat replacement
    bkt         # caching utility
    bob-nvim    # provides neovim
    fnm         # provides npm/node
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

PIP=(
    "${PIP[@]}"

    'yt-dlp' # ytdl fork
)

# these commands will be executable from within the container, commands that
# require root wont work as the container is not priviledged and should not be
DISTROBOX_HOST_EXEC=(
    "${DISTROBOX_HOST_EXEC[@]}"

    flatpak
    podman
)

# detect if the host has rpm-ostree
if command -v rpm-ostree &>/dev/null; then
    DISTROBOX_HOST_EXEC=(
        "${DISTROBOX_HOST_EXEC[@]}"

        rpm-ostree
        # i did not add ostree as many commands require root
    )
fi

