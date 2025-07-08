#!/usr/bin/env bash
# simple task plugin
#
# requires rofi

set -eo pipefail

TASK_DIR="$HOME/.local/share/task"
TASK_FILE="$TASK_DIR/taskfile"
TASK_FILE_TEMP="${TASK_FILE}.temp"
TASK_LOCKFILE="$TASK_DIR/lockfile"

# ensure everything exists
mkdir -p "$TASK_DIR"
touch "$TASK_FILE"

function lock() {
    # lockfile so nothing goes wrong
    if [[ -e "$TASK_LOCKFILE" ]]; then
        echo "Lockfile exists at '$TASK_LOCKFILE', qutting.."
        exit 66
    fi

    touch "$TASK_LOCKFILE"
}

function unlock() {
    rm -f "$TASK_LOCKFILE"
}

POSITIONAL_ARGS=()

case "$1" in
    reset)
        lock
        
        echo "" > "$TASK_FILE"

        unlock
        ;;
    current-short)
        current=$("$0" current)

        # do not shorten if it does not contain periods
        if [[ "$current" == *"."* ]]; then
            # cut everything after first period
            current_temp="${current#*.}"
            current="${current%"$current_temp"}"

            # trim the period
            current="${current%%.}"
        fi

        echo "$current"
        ;;
    current-long)
        current=$("$0" current)

        # do not print anything if there is no long part
        if [[ "$current" == *"."* ]]; then
            # cut everything before first period
            current="${current#*.}"

            # trim space after period
            current="${current## }"

            echo "$current"
        fi
        ;;
    current) # print only the first line
        head -n 1 "$TASK_FILE"
        ;;
    list) # print all but the first line
        tail -n +2 "$TASK_FILE"
        ;;
    add) # append new line
        read -p "Task: " task
        if [[ -z "$task" ]]; then
            echo "Cancelled."
            exit 0
        fi

        lock
        echo "$task" >> "$TASK_FILE"
        unlock
        ;;
    start)
        lock
        
        # get all tasks
        taskfile="$("$0" list)"

        # ask via rofi dmenu mode (allows custom input)
        ans="$(echo "$taskfile" | rofi -dmenu)"

        # if empty do not do anything
        if [[ -n "$ans" ]]; then
            # add the new current task
            echo "$ans" > "$TASK_FILE_TEMP"

            # add the new task to the list if it was not present
            if ! grep -qw "$ans" "$TASK_FILE"; then
                echo "$ans" >> "$TASK_FILE_TEMP"
            fi

            # restore old tasks
            echo "$taskfile" >> "$TASK_FILE_TEMP"

            # move the new file
            mv "$TASK_FILE_TEMP" "$TASK_FILE"
        fi

        unlock
        ;;
    stop) # removes the task from being the active one (does not delete it)
        lock
        
        # get all tasks
        taskfile="$("$0" list)"

        # add empty task
        echo "" > "$TASK_FILE_TEMP"

        # restore old tasks
        echo "$taskfile" >> "$TASK_FILE_TEMP"

        # move the new file
        mv "$TASK_FILE_TEMP" "$TASK_FILE"

        unlock
        ;;
    done) # delete a task
        curr="$("$0" current)"

        if [[ -z "$curr" ]]; then
            exit 0
        fi
        
        lock

        # get all tasks but remove the current one (should also remove current task)
        taskfile="$(grep -vw "$curr" "$TASK_FILE")"

        # add empty task
        echo "" > "$TASK_FILE_TEMP"

        # restore old tasks
        echo "$taskfile" >> "$TASK_FILE_TEMP"

        # move the new file
        mv "$TASK_FILE_TEMP" "$TASK_FILE"

        unlock
        ;;
    waybar)
        short="$("$0" current-short)"
        if [[ -z "$short" ]]; then
            echo -n "{\"text\": \"\", \"tooltip\": \"No task active\", \"alt\": \"inactive\", \"class\": \"inactive\"}"
            exit 0
        fi

        long="$("$0" current-long)"
        echo -n "{\"text\": \"$short\", \"tooltip\": \"$long\", \"alt\": \"active\", \"class\": \"active\"}"
        ;;
    *)
        echo "Unknown command '$1'"
        exit 1
        ;;
esac
