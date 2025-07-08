#!/usr/bin/env python3
# simple brightness script for waybar

import sys
import subprocess
import re

PAT_VALUE = re.compile(r"current value =\s*(\d+)")
def get_value(monitor):
    try:
        process = subprocess.run(["ddcutil", "--model", monitor, "getvcp", "10"], capture_output=True, check=True)
    except subprocess.CalledProcessError:
        # prevent failure as it messes with waybar
        return "?"

    stdout = process.stdout.decode("utf-8")
    matches = PAT_VALUE.search(stdout)

    return matches.group(1)

def set_value(monitor, value):
    subprocess.run(["ddcutil", "--model", monitor, "setvcp", "10", str(value)], capture_output=True)

def increment_value(monitor, value):
    sign = "+"
    if value < 0:
        sign = "-"
        value *= -1

    assert(value >= 0)
    
    subprocess.run(["ddcutil", "--model", monitor, "setvcp", "10", sign, str(value)], capture_output=True)

if len(sys.argv) < 3:
    print("""Usage: {} <cmd>

Commands:
    tooltip <MONITORS...>
    get <MONITORS...>
    set <VALUE> <MONITORS...>
    inc <VALUE> <MONITORS...>
    dec <VALUE> <MONITORS...>
""".format(sys.argv[0]))
    sys.exit(1)

match sys.argv[1]:
    case "tooltip":
        output = ""

        for monitor in sys.argv[2:]:
            output += "{} {:>10}\r".format(monitor, get_value(monitor))

        print(output.rstrip(), end="")

        sys.exit(0)
    case "get":
        output = ""
        
        for monitor in sys.argv[2:]:
            output += "{}\r".format(get_value(monitor))

        print(output.rstrip(), end="")

        sys.exit(0)
    case "set":
        val = sys.argv[2]
        monitors = sys.argv[3:]

        try:
            val = abs(int(val))
        except ValueError:
            print(f"Invalid value {val}")
            sys.exit(1)

        # clamp the value
        if val > 100:
            val = 100

        for monitor in monitors:
            set_value(monitor, val)
    case "inc":
        val = sys.argv[2]
        monitors = sys.argv[3:]

        try:
            val = abs(int(val))
        except ValueError:
            print(f"Invalid value {val}")
            sys.exit(1)

        # clamp the value
        if val > 100:
            val = 100

        for monitor in monitors:
            increment_value(monitor, val)
    case "dec":
        val = sys.argv[2]
        monitors = sys.argv[3:]

        try:
            val = abs(int(val))
        except ValueError:
            print(f"Invalid value {val}")
            sys.exit(1)

        # clamp the value
        if val > 100:
            val = 100

        for monitor in monitors:
            increment_value(monitor, -val)
