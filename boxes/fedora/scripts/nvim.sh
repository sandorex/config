#!/usr/bin/env bash
# script that sets up neovim

set -eu

buildah run "$ctx" sh -c 'cat > /usr/local/bin/bootstrap-nvim; chmod +x /usr/local/bin/bootstrap-nvim' <<'EOF'
#!/usr/bin/env bash

set -euo pipefail

# if the directory is empty, bootstrap neovim
if [[ ! -d ~/.local/share/nvim ]] || [[ -z "$(ls -A ~/.local/share/nvim)" ]]; then
    echo "Bootstrapping neovim"
    nvim --headless +Bootstrap +q
else
    echo "Neovim already bootstrapped"
fi
EOF
