#!/bin/bash
#
# bootstrap.sh - bootstraps the config
#
# run using `curl -s https://raw.githubusercontent.com/sandorex/config/master/bootstrap/bootstrap.sh | bash -s`

REPO="https://github.com/sandorex/config"
CONFIG_DIR=${1:~/config}

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# clone the repository
git clone "$REPO" "$CONFIG_DIR"

if ! command -v brew &>/dev/null; then
    cat << 'EOF'

Install homebrew using following command:
    $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

EOF
    cat << EOF
To install packages run:
    $ brew install $(grep -e '^[^#]' "$DIR"/brew.list | xargs -d '\n')

EOF
fi

if command -v nix-env &>/dev/null; then
    cat << 'EOF'

Install nix using one of following commands:
  Multi-user (recommended on everything except SELinux enforced systems)
    $ sh <(curl -L https://nixos.org/nix/install) --daemon

  Single-user
    $ sh <(curl -L https://nixos.org/nix/install) --no-daemon

EOF
    cat << EOF
To install packages run:
    $ nix-env -iA $(grep -e '^[^#]' "$DIR"/nix.list | xargs -d '\n')"

EOF
fi

