#!/bin/sh
#
# .profile - place to put env vars
#
# THIS SHOULD NOT RUN ON START OF EACH SHELL
# SYMLINK ~/.zprofile TO THIS FILE

export DOTFILES="$HOME/.dotfiles"       # dotfiles path
export AGSHELLDIR="$HOME/.config/shell" # agnostic shell stuff
export RUSTUP_HOME="$HOME/.rustup"
export GOPATH="$HOME/.golang"           # GOPATH defaults to $HOME/go ugh
export NPM_HOME="$HOME/.npm-packages"   # npm global user install

PATH="$PATH:$HOME/.bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$GOPATH/bin"
PATH="$PATH:$NPM_HOME/bin"
PATH="$PATH:$HOME/.bin/polyfill"        # fallback path for optional software

export PATH

# this section basically select editor levels based on what is installed, it
# does more than profile script should but its only a tiny startup penalty and
# should not be evaluated again

# editors listed in startup time
EDITOR1=nano
EDITOR2="$EDITOR1"
EDITOR3="$EDITOR1"

if command -v nvim >/dev/null; then
    EDITOR2=nvim

    # fallback to previous editor in case it does not exist
    EDITOR3=nvim
fi

if command -v vscodium >/dev/null; then
    EDITOR3=vscodium
fi

export EDITOR1
export EDITOR2
export EDITOR3

export EDITOR="$EDITOR1"
export SUDO_EDITOR="$EDITOR1"
export FILE_MANAGER=ranger

export TASK_PAGER=glow

# options for less
# FRX is git default, adding mouse for mousewheel scrolling
export LESS='FRX --mouse'

# use ansi based theme so terminal theme does not make it unreadable
export BAT_THEME='ansi'

# set default distrobox defaults
export DBX_CONTAINER_HOSTNAME="$(uname -n)"
export DBX_CONTAINER_NAME=dev
export DBX_CONTAINER_GENERATE_ENTRY=0

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# set ls colors
eval "$(dircolors --sh "$AGSHELLDIR/util/gruvbox.dircolors")"

# theme bare shell if ran in it
"$AGSHELLDIR/util/console-theming.sh"

# sets env var based on distro its running on
source "$AGSHELLDIR/util/distro-icon.sh"

# check if sourced again needlessly
[ -n "$__PROFILE_RAN" ] && echo "This unefficiency is unacceptable, ~/.profile was sourced twice!"
export __PROFILE_RAN=1

