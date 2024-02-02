#!/bin/sh
#
# https://github.com/sandorex/config
# finds distro icon and color for known distros using os-release
#
# requires nerdfonts

# i do not want to source it
id="$(perl -lne 'print $1 if /^ID=(.+)/' < /etc/os-release)"

# checked the ids with https://github.com/chef/os_release
case "$id" in
    fedora)
        PROMPT_ICON_UTF8='󰣛'
        PROMPT_ICON_ASCII='f'
        PROMPT_ICON_COLOR=6
        ;;
    *ubuntu*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='U'
        PROMPT_ICON_COLOR=202
        ;;
    *debian*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='D'
        PROMPT_ICON_COLOR=1
        ;;
    *suse*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='SUSE'
        PROMPT_ICON_COLOR=10
        ;;
    *arch*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Arch'
        PROMPT_ICON_COLOR=12
        ;;
    nixos)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Nix'
        PROMPT_ICON_COLOR=14
        ;;
    linuxmint)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Mint'
        PROMPT_ICON_COLOR=10
        ;;
    pop)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Pop'
        PROMPT_ICON_COLOR=51
        ;;
    rocky)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='ROCK'
        PROMPT_ICON_COLOR=10
        ;;
    elementary)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='e'
        PROMPT_ICON_COLOR=15
        ;;
    gentoo)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='gen'
        PROMPT_ICON_COLOR=12
        ;;
    *)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='LNX?'
        PROMPT_ICON_COLOR='15'
        ;;
esac

# clean up
unset id

# "smart" switching for dumb terminals
case "$TERM" in
    linux)
        PROMPT_ICON="$PROMPT_ICON_ASCII"
        ;;
    *)
        PROMPT_ICON="$PROMPT_ICON_UTF8"
        ;;
esac

export PROMPT_ICON_UTF8
export PROMPT_ICON_ASCII
export PROMPT_ICON_COLOR
export PROMPT_ICON

