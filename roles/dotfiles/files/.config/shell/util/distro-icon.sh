#!/bin/sh
# finds distro icon and color for known distros using os-release

# i do not want to source it
id="$(cat /etc/os-release | awk '/^ID=(.+)$/ { print substr($1, 4); exit(0); }')"

# checked the ids with https://github.com/chef/os_release
case "$id" in
    fedora)
        PROMPT_ICON_UTF8='󰣛'
        PROMPT_ICON_ASCII='f'
        PROMPT_ICON_COLOR=6
        PROMPT_ICON_COLOR_HEX='3C6EB4'
        ;;
    *ubuntu*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Ub'
        PROMPT_ICON_COLOR=202
        PROMPT_ICON_COLOR_HEX='E95420'
        ;;
    *debian*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Deb'
        PROMPT_ICON_COLOR=1
        PROMPT_ICON_COLOR_HEX='D0074F'
        ;;
    *suse*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='SUSE'
        PROMPT_ICON_COLOR=10
        PROMPT_ICON_COLOR_HEX='73ba25'
        ;;
    *arch*)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Arch'
        PROMPT_ICON_COLOR=12
        PROMPT_ICON_COLOR_HEX='1793d1'
        ;;
    nixos)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Nix'
        PROMPT_ICON_COLOR=14
        PROMPT_ICON_COLOR_HEX='7EBAE4'
        ;;
    linuxmint)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Mint'
        PROMPT_ICON_COLOR=10
        PROMPT_ICON_COLOR_HEX='86BE43'
        ;;
    pop)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='Pop'
        PROMPT_ICON_COLOR=51
        PROMPT_ICON_COLOR_HEX='43BBC9'
        ;;
    rocky)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='ROCK'
        PROMPT_ICON_COLOR=10
        PROMPT_ICON_COLOR_HEX='10B981'
        ;;
    elementary)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='eOS'
        PROMPT_ICON_COLOR=15
        PROMPT_ICON_COLOR_HEX='FFFFFF'
        ;;
    gentoo)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='gen'
        PROMPT_ICON_COLOR=12
        PROMPT_ICON_COLOR_HEX='3E365B'
        ;;
    *)
        PROMPT_ICON_UTF8=''
        PROMPT_ICON_ASCII='LINX'
        PROMPT_ICON_COLOR='15'
        PROMPT_ICON_COLOR_HEX='FFFFFF'
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
export PROMPT_ICON_COLOR_HEX
export PROMPT_ICON

