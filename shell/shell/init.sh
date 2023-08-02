#!/usr/bin/env bash
#
# https://github.com/sandorex/config
# initialization, ran by shells but not sourced!

if command -v task &>/dev/null; then
    if task_name="$(task current)"; then
        echo "Current task: $task_name"
    fi
fi

