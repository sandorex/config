#!/usr/bin/env bash
# neovim boostrap script
# explicitly enable/disable it
[[ -v BOOTSTRAP_NVIM ]] || exit 0

# if the directory is empty, bootstrap neovim
if [[ ! -d ~/.local/share/nvim ]] || [[ -z "$(ls -A ~/.local/share/nvim)" ]]; then
    echo "Bootstrapping neovim"
    nvim --headless +Bootstrap +q
else
    echo "Neovim already bootstrapped"
fi
