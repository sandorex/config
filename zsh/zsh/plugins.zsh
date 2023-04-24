#!/usr/bin/env zsh
#
# plugins.zsh - file where all plugin initialization and configuration resides

# sudo plugin, press escape to sudo a command
source "${0:A:h}"/plugins/ohmyzsh/plugins/sudo/sudo.plugin.zsh

# fish like abbreviations
source "${0:A:h}"/plugins/abbrevs.zsh

# THIS HAS TO BE LAST!!
# syntax highlighting
source "${0:A:h}"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

