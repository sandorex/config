#!/usr/bin/env zsh
#
# startup.zsh - startup script for the container

cat <<EOF
Welcome to config-toolbox container, all basic tools should have been installed
To install more specific tools like cpp, run `config-lang cpp`

EOF

exec zsh
