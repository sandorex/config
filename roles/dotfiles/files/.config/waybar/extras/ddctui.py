#!/usr/bin/env python3
# simple TUI to change brightness of monitors

import sys
import os
import subprocess
import re

class Monitor():
    def __init__(self, display=None, serial=None, model=None, busid=None):
        self.display = display
        self.serial = serial
        self.model = model
        self.busid = busid

    def to_args(self):
        # https://www.ddcutil.com/display_selection/
        if self.busid: # busid is fastest
            return ["--bus", self.busid]
        elif self.display:
            return ["--display", self.display]
        elif self.serial:
            return ["--sn", self.serial]
        elif self.model:
            return ["--model", self.model]
        else:
            raise RuntimeError("Filter is empty")

    # show the monitors by their filters, bit overkill
    def __str__(self):
        output = ""
        if self.display:
            output += f"#{self.display} "

        if self.model:
            output += f"{self.model} "

        if self.serial:
            output += f"({self.serial}) "

        # fallback
        if len(output) == 0:
            output = f"bus={self.busid}"

        return output

    @classmethod
    def by_display(cls, display):
        return cls(display=display)

    @classmethod
    def by_serial(cls, serial):
        return cls(serial=serial)
    
    @classmethod
    def by_model(cls, model):
        return cls(model=model)

    @classmethod
    def by_busid(cls, busid):
        return cls(busid=busid)

PAT_SPLIT = re.compile(r"Display (\d+)")
PAT_BUSID = re.compile(r"I2C bus:\s*([^\n\r]+)")
PAT_MODEL = re.compile(r"Model:\s*([^\n\r]+)")
PAT_SERIAL = re.compile(r"Serial number:\s*([^\n\r]+)")
def get_monitors():
    monitors = []
    
    process = subprocess.run(["ddcutil", "detect"] , capture_output=True, check=True)
    stdout = process.stdout.decode("utf-8")
    split = PAT_SPLIT.split(stdout)

    # remove empty string
    if not split[0]:
        split.pop(0)

    for i in range(0, len(split), 2):
        display = split[i]
        text = split[i + 1]
        
        assert(display.isdigit())

        busid = PAT_BUSID.search(text).group(1)
        model = PAT_MODEL.search(text).group(1)
        serial = PAT_SERIAL.search(text).group(1)

        monitors.append(Monitor(display=display, busid=busid, model=model, serial=serial))
        
    return monitors

PAT_VALUE = re.compile(r"current value =\s*(\d+)")
def get_value(monitor):
    process = subprocess.run(["ddcutil"] + monitor.to_args() + ["getvcp", "10"], capture_output=True, check=True)
    stdout = process.stdout.decode("utf-8")
    matches = PAT_VALUE.search(stdout)

    return matches.group(1)

def set_value(monitor, value):
    subprocess.run(["ddcutil"] + monitor.to_args() + ["setvcp", "10", str(value)], capture_output=True, check=True)

def increment_value(monitor, value):
    sign = "+"
    if value < 0:
        sign = "-"
        value *= -1

    assert(value >= 0)
    
    subprocess.run(["ddcutil"] + monitor.to_args() + ["setvcp", "10", sign, str(value)], capture_output=True, check=True)

def term(cmd):
    """
    Basically using tput and clear i can cache all the escape codes and reuse them later without process codes  
    """
    process = subprocess.run(cmd, capture_output=True, check=True)
    stdout = process.stdout.decode("utf-8")
    return stdout

term_clear_screen = term("clear")
term_reset = term("tput sgr0")
term_bold = term("tput setaf")
term_fg_color = term("tput setaf 3")
term_bg_color = term("tput setab 3")

monitors = get_monitors();

# if len(monitors) == 0:
#     print("No compatible monitors found, qutting..")
#     sys.exit(1)

# for i in get_monitors():
#     print(i)
# print(get_monitors())
# monitor = Monitor(model="DELL U2414H", serial="awf2f22")
# print(monitor)

# (cols, lines) = os.get_terminal_size()

# monitors = 

try:
    while True:
        # if sys.stdin.
        pass
except KeyboardInterrupt:
    print("Qutting..")
