#!/usr/bin/env bash
#
# install_fnm.sh

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

export FNM_DIR=/opt/fnm/

curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell --install-dir /usr/local/bin/
eval "$(fnm env)"
fnm use --install-if-missing lts-latest

