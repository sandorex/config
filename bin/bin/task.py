#!/usr/bin/env python3
#
# https://github.com/sandorex/config
# task v3 rewritten in python

import sys
import subprocess as sp
import os
import datetime
import click

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
    raise click.ClickException(msg)

def task_selected_or_abort():
    if not is_task_selected():
        abort("No task is selected")

def get_tasks() -> List[Path]:
    return [ dir for dir in TASK_DIR.iterdir() if dir.is_dir() and not dir.is_symlink() ]

def make_timestamp() -> str:
    return datetime.datetime.now().strftime(TIMESTAMP_FORMAT)

def show(file):
    sp.run([PAGER, str(file)])

def show_raw(text: str):
    with sp.Popen([PAGER], stdin=sp.PIPE) as p:
        p.communicate(input=text.encode("UTF-8"))

def select_menu(msg, options, formatter_fn):
    click.echo(click.style(msg, fg="blue", bold=True))
    while True:
        for i, option in enumerate(options):
            click.secho(f"{i}) ", fg="blue", nl=False)
            click.echo(formatter_fn(option))

        answer = click.prompt("#) ", prompt_suffix="", type=int)
        try:
            return options[answer]
        except IndexError:
            click.echo("Invalid index", err=True)
            continue

@click.group(epilog="To change the editor or pager change either $TASK_EDITOR/$TASK_PAGER or $EDITOR/$PAGER")
@click.version_option("0.3")
def cli():
    pass

@cli.command("current")
def current_cmd():
    """Prints currently selected task"""
    task_selected_or_abort()

    click.echo(get_task_name())

@cli.command("new")
@click.argument("task_name")
def new_cmd(task_name):
    """Creates a new task"""
    task = TASK_DIR / task_name

    if task.exists():
        abort(f"Task '{task.name}' already exists")

    task.mkdir(exist_ok=True)

@cli.command("drop")
def drop_cmd():
    """Drops the current task, so there is no task selected"""
    task_selected_or_abort()

    click.echo(f"Dropping task '{get_task_name()}'")
    TASK_LINK.unlink(missing_ok=True)

@cli.command("select")
@click.argument("task-name", metavar="[<task-name>]", required=False)
def select_cmd(task_name):
    """Select the current task, if no arguments provided then allows user to
    choose which task to select"""

    if task_name:
        task = TASK_DIR / task_name
    else:
        task = select_menu("Choose a task", get_tasks(), lambda x: x.stem)

    if not task.exists():
        abort(f"Task '{task.name}' does not exist")

    click.echo(f"Selecting task '{task.name}'")
    TASK_LINK.unlink(missing_ok=True)
    TASK_LINK.symlink_to(task.name, target_is_directory=True)

@cli.command("log")
@click.argument("tags", nargs=-1)
def log_cmd(tags):
    """Creates new entry file in selected task if it does not already exist and opens in the editor"""
    task_selected_or_abort()

    # convert tags to uppercase
    tags = [ x.upper() for x in tags ]

    task = get_task()
    time = make_timestamp()
    entry = task / (time + ".md")

    if not entry.exists():
        entry.write_text(rf"""
## {" ".join(tags)}{" " if tags else ""}{time}
""")

    click.edit(filename=str(entry), editor=EDITOR)

@cli.command("status")
@click.argument("task_name", required=False)
def status_cmd(task_name):
    """Show last entry in selected task, or if argument is provided then use it instead"""
    task_selected_or_abort()

    # if provided try using that
    if task_name:
        task = TASK_DIR / task_name
    else:
        task = get_task()

    if not task.exists():
        abort(f"Task '{task.name}' does not exist")

    entries = list(task.glob("*.md"))
    entries = sorted(entries, key=lambda x: x.stem)
    if not entries:
        abort(f"No entries found in task '{task.name}'")

    show(entries[-1])

@cli.command("show")
def show_cmd(task):
    """Shows full task including all entries in sequence"""
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

@cli.command("edit")
def edit_cmd():
    """Edit one of entries of selected task"""
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
        file = select_menu("Select task entry", entries, lambda x: x.stem)

    click.edit(filename=str(file), editor=EDITOR)

@cli.command("summary")
def summary_cmd():
    """Shows last entry for each task"""
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

@cli.command("list")
def list_cmd():
    """Lists all tasks, one per line"""
    for i in get_tasks():
        click.echo(i.name)

if __name__ == "__main__":
    cli()

