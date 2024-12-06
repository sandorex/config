#!/usr/bin/env bash

set -e

echo "Setting up rustup"

sudo chown $USER:$USER /opt/rustup

# install nothing but rustup
rustup-init -y --default-toolchain none

cat <<EOF | sudo tee /usr/local/bin/bootstrap-rust >/dev/null
#!/usr/bin/env bash
echo "Installing stable rust toolchain with LSP extras"

# rust-analyzer and rust-src are needed for LSP
rustup-init -y \
    --no-modify-path \
    --default-toolchain stable \
    -c clippy \
    -c rust-analyzer \
    -c rust-src
EOF

sudo chmod +x /usr/local/bin/bootstrap-rust
