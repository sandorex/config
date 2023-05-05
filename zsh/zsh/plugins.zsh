#!/usr/bin/env zsh
#
# plugins.zsh - file where all plugin initialization and configuration resides

# fish like abbreviations
source "$HOME"/.config/shell/plugins/sha-abbr/sha-abbr.zsh

source "${0:A:h}"/plugins/quick-sudo.zsh
source "${0:A:h}"/plugins/job-switcher.zsh

# THIS HAS TO BE LAST!!
# syntax highlighting
source "${0:A:h}"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

