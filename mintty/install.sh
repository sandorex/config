#!/bin/bash
#
# install.sh - copies mintty/wsltty theme, must be ran in WSL

if ! grep -qi wsl /proc/version; then
    echo "This is for WSL only"
    exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

export PATH="$PWD/../bin/bin:$PATH"

if [[ -f .installed ]] && [[ -z "$REINSTALL" ]]; then
    echo "mintty/wsltty config already installed"
    exit
fi

cmd() {
    # cmd.exe complains if still in WSL directory
    pushd /mnt/c &>/dev/null || return 1
    /mnt/c/Windows/System32/cmd.exe /C "echo $1"
    popd &>/dev/null || return 1
}

WSLTTY_THEMES=%APPDATA%\\wsltty\\themes
MINTTY_THEMES=%HOMEDRIVE%%HOMEPATH%\\.mintty\\themes

wsltty_path=$(wslpath -u "$(cmd "$WSLTTY_THEMES")")
mintty_path=$(wslpath -u "$(cmd "$MINTTY_THEMES")")

util copy ./nightfox-carbonfox "$wsltty_path"
util copy ./nightfox-carbonfox "$mintty_path"

touch .installed
