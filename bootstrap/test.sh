#!/bin/bash
#
# test.sh - tests if all dependencies are installed

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Checking for missing required dependencies:"
for i in `grep -e '^[^#]' "$DIR"/deps.list | xargs -d '\n'`; do
    if ! command -v "$i" &>/dev/null; then
        echo "    $i"
    fi
done

echo

echo "Checking for optional dependencies"
for i in `grep -e '^[^#]' "$DIR"/opt-deps.list | xargs -d '\n'`; do
    printf "    $i"

    if ! command -v "$i" &>/dev/null; then
        printf " NOT FOUND!"
    fi

    echo
done


