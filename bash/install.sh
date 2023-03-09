#!/bin/bash
#
# install.sh - links bash config

cd "$(dirname "${BASH_SOURCE[0]}")"

. ../config.sh

link -a "$HOME"/.config/bash ./bash

if [[ ! -f "$HOME/.bashrc" ]]; then
    link -a "$HOME"/.bashrc ./bash/init.bash
else
    # load the init.bash from .bashrc
    cat <<'EOF' >> "$HOME"/.bashrc
# loads the actual configuration
[ -f "$HOME/.config/bash/init.bash" ] && \. "$HOME/.config/bash/init.bash"
EOF
fi
