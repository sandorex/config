#!/usr/bin/env bash
#
# install_rustup.sh - installs rustup globally, meant for use in a container!

if [[ -z "$container" ]]; then
    cat <<'EOF'

____    _    _   _  ____ _____ ____
|  _ \  / \  | \ | |/ ___| ____|  _ \
| | | |/ _ \ |  \| | |  _|  _| | |_) |
| |_| / ___ \| |\  | |_| | |___|  _ <
|____/_/   \_\_| \_|\____|_____|_| \_\

This script is meant for container use only!

EOF
exit 1
fi

export RUSTUP_HOME=/usr/local/rustup
export CARGO_HOME=/usr/local/cargo
export PATH=/usr/local/cargo/bin:$PATH

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
