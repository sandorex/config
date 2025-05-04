#!/usr/bin/env bash
# relatively simple bash install script, in case ansible cannot be used

set -e -o pipefail

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

LINK=0
DRY_RUN=0

function usage() {
    cat <<EOF
Usage: $0 [--dry-run] [--link] [<target directory>]

EOF
}

# copy file, works on links too
function copy() {
    local src="${1:?}"
    local dst="${2:?}"

    if [[ $DRY_RUN -eq 0 ]]; then
        mkdir -p "$(dirname "$dst")"

        cp -d --verbose \
            --recursive \
            --backup=simple \
            "$src" "$dst"
    else
        echo "Would copy $src to $dst"
    fi
}

# create an absolute path symlink
function link() {
    local src dst
    src="$(realpath "${1:?}")"
    dst="${2:?}"

    if [[ $DRY_RUN -eq 0 ]]; then
        mkdir -p "$(dirname "$dst")"

        # rough backup
        if [[ -d "$dst" ]]; then
            mv "$dst" "$dst~"
        fi

        ln --verbose \
            --no-target-directory \
            --symbolic \
            --relative \
            --backup=simple \
            "$src" "$dst"
    else
        echo "Would link $dst to $src"
    fi
}

# link if requested otherwise copy path
function copy_or_link() {
    if [[ $LINK -eq 1 ]]; then
        link "$@"
    else
        copy "$@"
    fi
}

# aliases to show changes better
function chmod() { command chmod --changes "$@"; }
function mkdir() { command mkdir --verbose --parents "$@"; }

POSITIONAL_ARGS=()

while [ $# -gt 0 ]; do
    case $1 in
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        --link)
            LINK=1
            shift
            ;;
        -h|--help)
            usage
            exit
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

# use the link to find dotfiles as they are quite deep and may move
DOTFILES="$(realpath "$(readlink dotfiles)")"

if [[ -n "$1" ]]; then
    TARGET="$1"
else
    TARGET="$HOME"
fi

echo "Installing into ${TARGET:?}"

# redirect output to log file as its long af
exec >install.log

# ssh
mkdir "$TARGET"/.ssh/connections
copy "$DOTFILES"/.ssh/config "$TARGET"/.ssh/config
chmod 600 "$TARGET"/.ssh/config
chmod 700 "$TARGET"/.ssh \
          "$TARGET"/.ssh/connections
echo

## shells
copy_or_link "$DOTFILES"/.profile "$TARGET"/.profile
copy_or_link "$DOTFILES"/.config/shell "$TARGET"/.config/shell

# bash
copy_or_link "$DOTFILES"/.bashrc "$TARGET"/.bashrc
copy_or_link "$DOTFILES"/.config/bash "$TARGET"/.config/bash

# zsh
copy_or_link "$DOTFILES"/.zshrc "$TARGET"/.zshrc
copy_or_link "$DOTFILES"/.config/zsh "$TARGET"/.config/zsh

copy_or_link "$DOTFILES"/.config/helix "$TARGET"/.config/helix

# TODO do the rest

