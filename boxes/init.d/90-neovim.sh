#!/usr/bin/env bash
# neovim boostrap script
#
# symlinks neovim plugins into /data/nvim to be preserved between containers

# using a link to store plugins and stuff in the persistent data volume
mkdir -p "$HOME/.local/share"
ln -sf /data/nvim "$HOME/.local/share/nvim"

if [[ -d /data/nvim ]]; then
    echo "Neovim cache exists"
else
    echo "Neovim cache not found, bootstrapping.."

    sudo mkdir /data/nvim
    sudo chown "$USER:$USER" /data/nvim
    nvim --headless +Bootstrap +q
fi
