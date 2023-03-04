#!/bin/bash
#
# distro-icon.sh - prints icon depending on distro

. /etc/os-release

get() {
    # checked with https://github.com/chef/os_release
    case "$1" in
        fedora|silverblue)
            printf ''
            ;;
        *ubuntu*)
            printf ''
            ;;
        *debian*)
            printf ''
            ;;
        *suse*|*opensuse*)
            printf ''
            ;;
        *arch*)
            printf ''
            ;;
        nixos)
            printf ''
            ;;
        linuxmint)
            printf ''
            ;;
        pop)
            printf ''
            ;;
        rocky)
            printf ''
            ;;
        manjaro)
            printf ''
            ;;
        elementary)
            printf ''
            ;;
        gentoo)
            printf ''
            ;;
        *)
            printf ''
            ;;
    esac
}

get $ID

