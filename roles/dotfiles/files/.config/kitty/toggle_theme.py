# kitten that toggles between two themes using symlinks, automatically reloads all kitty windows!
# usage: kitty @ kitten toggle_theme.py /path/to/link /path/to/theme1 /path/to/theme2

import os
import subprocess
import signal

from os.path import expanduser
from kittens.tui.handler import result_handler

# i have no need to block ui
def main(args):
    pass

@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    # i am lazy to handle args
    theme_link = expanduser(args[1])
    theme_light = expanduser(args[2])
    theme_dark = expanduser(args[3])

    try:
        curr = os.readlink(theme_link)

        # delete the link
        os.remove(theme_link)
    except FileNotFoundError:
        curr = theme_light

    if curr == theme_dark:
        os.symlink(theme_light, theme_link)
    else:
        # if any other just default to dark in case of any other themes
        os.symlink(theme_dark, theme_link)

    result = subprocess.run(["pgrep", "kitty"], capture_output=True, text=True)
    if result.returncode != 0:
        return "could not find kitty instances"

    pids = result.stdout.splitlines()
    for pid in pids:
        # get parent of process
        result = subprocess.run(["ps", "-o", "ppid=", pid], capture_output=True, text=True)
        if result.returncode != 0:
            # just skip it if it fails
            continue

        # strip whitespaces
        ppid = result.stdout.strip()

        # if its in the pids gathered earlier then the current pid is not the main process
        if ppid in pids:
            # skip it
            continue

        # this is a main process of a window so send USR1 to reload config
        os.kill(int(pid), signal.SIGUSR1)

