#!/usr/bin/env bash
# script that installs rustup

set -eu

# run once on startup to set the path and initialize rustup (if it is already installed paths will be set properly)
buildah run "$ctx" sh -c 'cat > /init.d/10-rustup.sh' <<'EOF'
#!/usr/bin/env bash
echo "Setting up rustup"

# install nothing but rustup
rustup-init -y --default-toolchain none &>/dev/null

EOF

# script to quickly install all the rustup things
buildah run "$ctx" sh -c 'cat > /usr/local/bin/bootstrap-rust; chmod +x /usr/local/bin/bootstrap-rust' <<'EOF'
#!/usr/bin/env bash
TOOLCHAIN="${1:-stable}"

echo "Installing $TOOLCHAIN rust toolchain with LSP extras"

sudo chown $USER:$USER /opt/rustup

# rust-analyzer and rust-src are needed for LSP
rustup-init -y \
    --default-toolchain "$TOOLCHAIN" \
    -c clippy \
    -c rust-analyzer \
    -c rust-src

EOF
