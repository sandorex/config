#!/usr/bin/env python3
#
# host.py - hosts http server for the kickstart files

import os
import sys
import subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler

# TODO list all valid kickstart files and flags

PORT = 8000

class MyHandler(BaseHTTPRequestHandler):
    def resp_invalid_path(self):
        self.send_response(404)
        self.end_headers()
        self.wfile.write(bytes('Invalid path\n', 'utf-8'))

    def resp_success(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        if self.path == '/':
            self.resp_invalid_path()
            return

        # split path
        segments = os.path.normpath(self.path).split(os.path.sep)
        if segments:
            # remove first empty segment
            segments = segments[1:]

        HOSTNAME = ''

        # parse flags out of the path
        flags = []
        for i in list(segments):
            if i.startswith('@'):
                flags.append(i[1:])
                segments.remove(i)
            if i.startswith('%'):
                HOSTNAME = i[1:]
                segments.remove(i)

        if flags:
            # remove duplicates
            flags = list(set(flags))

        # read the original file
        path = os.path.sep.join(segments)
        try:
            with open(path, 'r') as f:
                data = f.read()
        except FileNotFoundError:
            print(f"File not found '{path}'")
            self.resp_invalid_path()
            return

        # im lazy to make script each time i want a different hostname
        if HOSTNAME:
            print(f"Replacing hostname with '{HOSTNAME}'")
            data = data.replace('@HOSTNAME@', HOSTNAME)

        # run script for each flag
        for flag in flags:
            # get stdout but stderr goes straight to stdout
            data = subprocess.check_output([os.path.join('extras', flag), data], stderr=sys.stdout).decode('utf-8')

        self.resp_success()

        # write the final output
        self.wfile.write(bytes(data, 'utf-8'))

try:
    httpd = HTTPServer(('localhost', PORT), MyHandler)
    httpd.serve_forever()
except KeyboardInterrupt:
    print('Quitting..')
    exit(0)

