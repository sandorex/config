#!/usr/bin/env python3
#
# https://github.com/sandorex/config
# task v3 rewritten in python

import sys
import subprocess as sp
import os
import datetime
import shutil

from pathlib import Path
from typing import List, Any, Callable

TASK_DIR = Path("~/.taskpy").expanduser()
TASK_LINK = TASK_DIR / "@current"

# ISO8601 compatible format without colons and only hours cause there is no
# need for more than one entry per hour
TIMESTAMP_FORMAT = "%Y%m%dT%H"

EDITOR = os.environ.get("TASK_EDITOR", os.environ.get("EDITOR", "vi"))
PAGER = os.environ.get("TASK_PAGER", os.environ.get("PAGER", "less"))

os.makedirs(TASK_DIR, exist_ok=True)

def print_help(full=False):
    print(r"""Usage: task [<command>] [<command args..>]

If no command passed defaults to log command

Commands (uppercase letters are shorthand for that command):
    help       - Prints help message including some additional information
    Current    - Prints current task name, if no task is selected then exit
                 code is 1 and prints nothing
    new        - Creates new task
    Drop       - Unsets the current task
    select     - Selects a task, argument is task name, if no task name is
                 provided then user picks from a list
    Log        - Adds new log entry to the task then opens editor, arguments
                 are entry tags
    Status     - Shows the latest log entry
    show/ss    - Shows all the log entries concatenated into one file
    Edit       - Edit latest log entry
    summary/su - Shows latest log entry for each task, arguments are tasks to
                 show latest log if none are provided then shows for all tasks
    list/ls    - Lists all tasks, number of entries, date of latest entry
""")

    if full:
        print(rf"""Options
    TASK_DIR={TASK_DIR}
    EDITOR={EDITOR}

Customization
    Editor is set to either $TASK_EDITOR, $EDITOR or 'vi' in order
    Task directory is controlled using $TASK_DIR, defaults to '~/.task'
""")

def is_task_selected() -> bool:
    return TASK_LINK.exists()

def get_task() -> Path:
    task = TASK_LINK.readlink()
    if not task.is_absolute():
        task = TASK_DIR / task

    return task

def get_task_name() -> str:
    return get_task().name

def abort(msg):
    print(msg, file=sys.stderr)
    sys.exit(1)

def task_selected_or_abort():
    if not is_task_selected():
        abort("No task selected")

def get_tasks() -> List[Path]:
    return [ dir for dir in TASK_DIR.iterdir() if dir.is_dir() and not dir.is_symlink() ]

def select(options, formatter_fn: Callable) -> Any:
    '''Imitates the select shell command'''
    for i, option in enumerate(options):
        print(f"{i}) {formatter_fn(option)}")

    while True:
        try:
            answer = int(input("#) "))
            answer = options[answer]
        except (ValueError, IndexError):
            print("Invalid index", file=sys.stderr)
            continue

        break

    return answer

def make_timestamp() -> str:
    return datetime.datetime.now().strftime(TIMESTAMP_FORMAT)

def show(file):
    sp.run([PAGER, str(file)])

def show_raw(text: str):
    with sp.Popen([PAGER], stdin=sp.PIPE) as p:
        p.communicate(input=text.encode("UTF-8"))

def edit(file):
    sp.run([EDITOR, str(file)])

def main(args=sys.argv[1:]):
    try:
        cmd = args[0]
    except IndexError:
        cmd = None

    if cmd == "help":
        print_help(full=True)
        sys.exit(0)
    elif cmd in ["current", "c"]:
        task_selected_or_abort()

        print(get_task_name())
    elif cmd == "new":
        task = None
        try:
            task = TASK_DIR / args[1]
        except IndexError:
            abort("Please provide a task name")

        if task.exists():
            abort(f"Task '{task.name}' already exists")

        task.mkdir(exist_ok=True)
    elif cmd in ["drop", "d", "unset"]:
        task_selected_or_abort()

        print(f"Dropping task '{get_task_name()}'")
        TASK_LINK.unlink(missing_ok=True)
    elif cmd in ["select", "set"]:
        try:
            task = TASK_DIR / args[1]
        except IndexError:
            tasks = get_tasks()
            if len(tasks) == 0:
                abort("No tasks found")

            task = select(tasks, lambda x: x.name)

        if not task.exists():
            abort(f"Task '{task.name}' does not exist")

        print(f"Selecting task '{task.name}'")
        TASK_LINK.unlink(missing_ok=True)
        TASK_LINK.symlink_to(task.name, target_is_directory=True)
    elif cmd in ["log", "l"] or cmd is None:
        task_selected_or_abort()

        tags = [ x.upper() for x in args[1:] ]

        task = get_task()
        time = make_timestamp()
        entry = task / (time + ".md")

        if not entry.exists():
            entry.write_text(rf"""
## {" ".join(tags)}{" " if tags else ""}{time}
""")

        edit(entry)
    elif cmd in ["status", "s"]:
        task_selected_or_abort()

        task = get_task()
        entries = list(task.glob("*.md"))
        entries = sorted(entries, key=lambda x: x.stem)
        if not entries:
            abort(f"No entries found in task '{task.name}'")

        show(entries[-1])
    elif cmd in ["show", "ss", "export"]:
        task_selected_or_abort()

        task = get_task()
        entries = sorted(task.glob("*.md"), key=lambda x: x.stem)
        output = ""
        for i in entries:
            output += i.read_text()

        show_raw(rf"""
# TASK {task.name}
{output}
""")
    elif cmd in ["edit", "e"]:
        task_selected_or_abort()

        task = get_task()
        entries = list(task.glob("*.md"))
        entries = sorted(entries, key=lambda x: x.stem, reverse=True)

        if not entries:
            abort(f"No entries found in task '{task.name}'")

        # do not ask if there is only one
        if len(entries) == 1:
            file = entries[0]
        else:
            file = select(entries, lambda x: x.stem)

        edit(file)
    elif cmd in ["summary", "su"]:
        output = "**Summary**"
        for task in get_tasks():
            entries = list(task.glob("*.md"))
            entries = sorted(entries, key=lambda x: x.stem)
            if not entries:
                continue

            output += rf"""
# TASK {task.name}
{entries[-1].read_text()}
"""

        show_raw(output)
    elif cmd in ["list", "ls"]:
        for i in get_tasks():
            print(i.name)
    else:
        print("Invalid command")
        print_help()
        sys.exit(1)

if __name__ == "__main__":
    main()

