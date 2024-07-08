#!/usr/bin/env python3
# kitten that toggles between two themes using symlinks, automatically reloads all kitty windows!
# usage: kitty @ kitten darkmode_kitty [0|1]

import sys
import os
import subprocess
import signal

from os.path import expanduser

THEME_LINK = expanduser("~/.config/kitty/current-theme.conf")
THEME_DARK = os.readlink(expanduser("~/.config/kitty/dark-theme.conf"))
THEME_LIGHT = os.readlink(expanduser("~/.config/kitty/light-theme.conf"))

# reload config by sending USR1 signal to all main kitty processes
def reload_config():
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

def set_theme(args):
    try:
        curr = os.readlink(THEME_LINK)

        # delete the link
        os.remove(THEME_LINK)
    except FileNotFoundError:
        curr = THEME_LIGHT

    try:
        is_dark = args[1]
    except IndexError:
        is_dark = None

    # set explicitly if 0 or 1 otherwise toggle
    if is_dark == "1":
        os.symlink(THEME_DARK, THEME_LINK)
    elif is_dark == "0":
        os.symlink(THEME_LIGHT, THEME_LINK)
    else:
        if curr == THEME_DARK:
            os.symlink(THEME_LIGHT, THEME_LINK)
        else:
            # if any other just default to dark in case of any other themes
            os.symlink(THEME_DARK, THEME_LINK)

    reload_config()

# this is the kitty-only stuff
try:
    from kittens.tui.handler import result_handler

    # this is for kitty, no need for ui
    def main(args):
        pass

    @result_handler(no_ui=True)
    def handle_result(args, result, target_window_id, boss):
        set_theme(args)

except ImportError:
    if __name__ == "__main__":
        set_theme(sys.argv)
