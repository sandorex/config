#!/bin/sh
#
# https://github.com/sandorex/config
# finds distro icon and color for known distros using os-release
#
# requires nerdfonts

# i do not want to source it
id="$(perl -lne 'print $1 if /^ID=(.+)/' < /etc/os-release)"

# TODO add hex color as well

# checked the ids with https://github.com/chef/os_release
case "$id" in
    fedora)
        PROMPT_ICON_UTF8='󰣛'
        PROMPT_ICON='f'
        PROMPT_ICON_COLOR=6
        ;;
    *ubuntu*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='U'
        PROMPT_ICON_COLOR=202
        ;;
    *debian*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='D'
        PROMPT_ICON_COLOR=1
        ;;
    *suse*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='SUSE'
        PROMPT_ICON_COLOR=10
        ;;
    *arch*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='Arch'
        PROMPT_ICON_COLOR=12
        ;;
    nixos)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='Nix'
        PROMPT_ICON_COLOR=14
        ;;
    linuxmint)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='Mint'
        PROMPT_ICON_COLOR=10
        ;;
    pop)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='Pop'
        PROMPT_ICON_COLOR=51
        ;;
    rocky)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='ROCK'
        PROMPT_ICON_COLOR=10
        ;;
    elementary)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='e'
        PROMPT_ICON_COLOR=15
        ;;
    gentoo)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='gen'
        PROMPT_ICON_COLOR=12
        ;;
    *)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON='LNX?'
        PROMPT_ICON_COLOR='15'
        ;;
esac

unset id

export PROMPT_ICON_UTF8
export PROMPT_ICON
export PROMPT_ICON_COLOR

