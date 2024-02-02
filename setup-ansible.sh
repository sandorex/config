#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# script sets up ansible using python venv, each python version has its own
# venv as it often breaks without errors if there is a mismatch in versions

export VENV_BASE_DIR="venv"

if ! command -v python3 &>/dev/null; then
    echo "Python3 was not found"
    return 1
fi

# get version string like 3.11, 3.14, ..
PYTHON_VERSION="py$(python3 -c 'import sys; print(str(sys.version_info.major) + "." + str(sys.version_info.minor))')"

mkdir -p "$VENV_BASE_DIR"

export VENV_DIR="$VENV_BASE_DIR/$PYTHON_VERSION"


# check if venv is already created
if [[ ! -d "$VENV_DIR" ]]; then
    # create venv
    if ! python3 -m venv --prompt "ansible venv" "$VENV_DIR"; then
        echo "Failed creating python virtualenv, is python3-venv installed?"
        return 1
    fi
fi

# activate virtualenv
if ! source "$VENV_DIR/bin/activate"; then
    echo "Failed to activate virtualenv, try deleteing './$VENV_DIR'"
    exit 1
fi

# install ansible-core if not present
if ! command -v ansible-playbook &>/dev/null; then
    pip install ansible-core
fi

echo
echo "You can exit out of the virtualenv using 'deactivate' command"
echo

