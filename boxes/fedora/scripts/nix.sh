#!/usr/bin/env bash
# script that installs nix automatically
# requires curl

set -eu

echo
echo "Installing Nix package manager"

buildah run "$ctx" sh -c 'sh <(curl -L https://nixos.org/nix/install) --daemon --yes'

# daemon is required for nix to work properly
buildah run "$ctx" sh -c 'cat > /init.d/10-nix.sh' <<EOF
#!/usr/bin/env bash
# execute nix daemon on startup

echo "Executing nix-daemon"

# execute daemon and disown it
nohup sudo /nix/var/nix/profiles/default/bin/nix-daemon &> /dev/null &
EOF
