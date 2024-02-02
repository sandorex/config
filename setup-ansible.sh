#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# script sets up ansible using python venv, requires python3 and python3-venv

VENV_DIR="venv"

if ! command -v python3 &>/dev/null; then
    echo "Python3 was not found"
    return 1
fi

# check if venv is already created
if [[ ! -d "$VENV_DIR" ]]; then
    # create venv
    if ! python3 -m venv "$VENV_DIR"; then
        echo "Failed creating python virtualenv, is python3-venv installed?"
        return 1
    fi
fi

if [[ ! -f "$VENV_DIR/bin/activate" ]]; then
    echo "Activate script was not found in virtaulenv, try deleting './$VENV_DIR'"
    return 1
fi

# activate virtualenv
source "$VENV_DIR/bin/activate"

# install ansible if not present
if ! command -v ansible &>/dev/null; then
    pip install ansible
fi
