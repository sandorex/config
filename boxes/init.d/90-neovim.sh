#!/usr/bin/env bash
# neovim boostrap script

# if the directory is empty, bootstrap neovim
if [[ -z "$(ls -A ~/.local/share/nvim)" ]]; then
    echo "Bootstrapping neovim"
    nvim --headless +Bootstrap +q
else
    echo "Neovim already bootstrapped"
fi
