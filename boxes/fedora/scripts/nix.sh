#!/usr/bin/env bash
# script that installs nix automatically
# requires curl

set -eu

echo
echo "Installing Nix package manager"

buildah run "$ctx" sh -c 'sh <(curl -L https://nixos.org/nix/install) --daemon --yes'

# enable flakes
buildah run "$ctx" sh -c 'cat > /etc/nix/nix.conf' <<EOF
experimental-features = nix-command flakes

EOF

# daemon is required for nix to work properly
buildah run "$ctx" sh -c 'cat > /init.d/10-nix.sh' <<EOF
#!/usr/bin/env bash
# execute nix daemon on startup

echo "Executing nix-daemon"

# execute daemon and disown it
nohup sudo /nix/var/nix/profiles/default/bin/nix-daemon &> /dev/null &

# if nix is mounted, set it up properly
if findmnt /nix &>/dev/null &>/dev/null; then
    if [ "$(ls -A /nix)"]; then
        # the volume is empty so copy whole store
        asroot cp -ra /nix-builtin/* /nix/
    else
        # volume is not empty so just copy packages
        # login shell so nix is in PATH
        asroot sh -l -c 'nix copy --all --from file:///nix-builtin/store'
    fi
fi

EOF
