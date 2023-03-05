#!/usr/bin/env bash
#
# wvm.sh - configuration for the Work Virtual Machine

cd "$(dirname "${BASH_SOURCE[0]}")/.."

# scripts
./bin/install.sh

# shell agnostic stuff
./shell/install.sh

# other commonly used software
./git/install.sh
./inputrc/install.sh
./bash/install.sh
./nvim/install.sh
./tmux/install.sh

