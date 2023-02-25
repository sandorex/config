#!/bin/bash
#
# install.sh - links bash config, if the bashrc does not exist then adds a shim that loads init.bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link the bash dir
ln -sfb "$DIR"/bash "$HOME"/.config/bash

if [[ ! -f "$HOME/.bashrc" ]]; then
    # this does not need to be a link as its a shim and should not change
    cp "$DIR"/.bashrc "$HOME"/.bashrc
else
    # load the init.bash from .bashrc
    cat <<'EOF' >> "$HOME"/.bashrc
# loads the actual configuration
[ -f "$HOME/.config/bash/init.bash" ] && \. "$HOME/.config/bash/init.bash"
EOF
fi
