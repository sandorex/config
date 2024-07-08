#!/usr/bin/env python3
#
# Daemon that runs in background and trigger changes when color scheme changes
#
# relies on xdg-desktop-portal color-scheme setting

import sys
import os
import glob
import time
import datetime
import subprocess

from pathlib import Path
from dasbus.connection import SessionMessageBus, SystemMessageBus
from dasbus.loop import EventLoop

scripts_dir = None

TIMESTAMP_FILE = ".timestamp"

# this function returns how many seconds was the theme changes last
def time_since_last_change() -> int:
    if not os.path.exists(os.path.join(scripts_dir, TIMESTAMP_FILE)):
        elapsed_time = 1000000 # some random big number
    else:
        elapsed_time = time.time() - os.path.getmtime(os.path.join(scripts_dir, TIMESTAMP_FILE))

    Path(os.path.join(scripts_dir, TIMESTAMP_FILE)).touch()

    return elapsed_time

def execute_all(is_dark: int):
    # prevent running more than once per second
    if time_since_last_change() <= 1:
        return

    print(f"Triggered is_dark={is_dark}")

    for file in glob.glob(scripts_dir + "/*"):
        # skip this script itself
        if os.path.samefile(file, __file__):
            continue

        if os.access(file, os.X_OK):
            print("executing ", file)
            try:
                subprocess.check_call([file, str(is_dark)])
            except subprocess.CalledProcessError:
                print("failed..")

def callback(namespace, key, value_variant):
    if namespace == "org.freedesktop.appearance" and key == "color-scheme":
        if value_variant.unpack() == 1:
            execute_all(1)
        else:
            execute_all(0)

def main(args):
    global scripts_dir

    try:
        scripts_dir = args[1]
    except IndexError:
        print("Usage: " + args[0] + " <scripts_dir>")
        sys.exit(1)

    bus = SessionMessageBus()
    loop = EventLoop()

    proxy = bus.get_proxy(
        "org.freedesktop.portal.Desktop", # service
        "/org/freedesktop/portal/desktop", # obj path
        "org.freedesktop.portal.Settings", # interface
    )

    proxy.SettingChanged.connect(callback)

    try:
        loop.run()
    except KeyboardInterrupt:
        print("\nQuitting..")
        exit(0)

if __name__ == "__main__":
    main(sys.argv)
