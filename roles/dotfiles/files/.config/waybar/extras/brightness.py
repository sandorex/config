#!/usr/bin/env python3
# simple script to change monitor brightness supporting multiple monitors at once

import sys
import subprocess
import re

PAT_VALUE = re.compile(r"current value =\s*(\d+)")
def get_value(monitor):
    process = subprocess.run(["ddcutil", "--model", monitor, "getvcp", "10"], capture_output=True, check=True)
    stdout = process.stdout.decode("utf-8")
    matches = PAT_VALUE.search(stdout)

    return matches.group(1)

def set_value(monitor, value):
    subprocess.run(["ddcutil", "--model", monitor, "setvcp", "10", str(value)], capture_output=True, check=True)

def increment_value(monitor, value):
    sign = "+"
    if value < 0:
        sign = "-"
        value *= -1

    assert(value >= 0)
    
    subprocess.run(["ddcutil", "--model", monitor, "setvcp", "10", sign, str(value)], capture_output=True, check=True)

if len(sys.argv) < 3:
    print("Usage: {} <[ + | - ]brightness | get> <MONITOR MODELS...>".format(sys.argv[0]))
    sys.exit(1)

increment = False
val = sys.argv[1]
monitors = sys.argv[2:]

match val[:1]:
    case "-" | "+":
        increment = True
    case "@":
        output = ""
        
        for monitor in monitors:
            output += "{} {}\r".format(monitor, get_value(monitor))

        print(output.rstrip(), end="")

        sys.exit(0)
    case _:
        print(f"Invalid argument '{val}'")
        sys.exit(1)

if val[:1] == "-" or val[:1] == "+":
    increment = True

try:
    val = int(val)
except ValueError:
    print(f"Invalid value {val}")
    sys.exit(1)

# clamp the value
if val > 100:
    val = 100
elif val < -100:
    val = -100

for monitor in monitors:
    if increment:
        increment_value(monitor, val)
    else:
        set_value(monitor, val)
