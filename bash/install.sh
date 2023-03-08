#!/bin/bash
#
# install.sh - links bash config, if the bashrc does not exist then adds a shim that loads init.bash

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link ./bash "$HOME"/.config/bash

if [[ ! -f "$HOME/.bashrc" ]]; then
    link ./bash/init.bash "$HOME"/.bashrc
else
    # load the init.bash from .bashrc
    cat <<'EOF' >> "$HOME"/.bashrc
# loads the actual configuration
[ -f "$HOME/.config/bash/init.bash" ] && \. "$HOME/.config/bash/init.bash"
EOF
fi
