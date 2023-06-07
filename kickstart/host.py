#!/usr/bin/env python3
#
# host.py - hosts http server for the kickstart files

import os
import sys
import subprocess
import argparse
import re

from http.server import HTTPServer, BaseHTTPRequestHandler

parser = argparse.ArgumentParser(description="Runs a HTTP server to host kickstart file with optional templating")
parser.add_argument('-p', '--port', type=int, help='Port for the HTTP server', default=8000)
parser.add_argument('-a', '--addr', help='Address for the HTTP server (defaults to 0.0.0.0)', default='0.0.0.0')

parser.add_argument('--default', help='Default path to redirect to if no path is used (aka root /)')

ARGS = parser.parse_args()

class MyHandler(BaseHTTPRequestHandler):
    def resp_invalid_path(self):
        self.send_response(404)
        self.end_headers()
        self.wfile.write(bytes('Invalid path\n', 'utf-8'))

    def resp_success(self):
        self.send_response(200)
        self.end_headers()

    def redirect(self, path):
        self.send_response(301)
        self.send_header('Location', path)
        self.end_headers()

    def do_GET(self):
        if self.path == '/' or not self.path:
            if ARGS.default:
                # redirect to default
                self.redirect(ARGS.default)
                return

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
            data = re.sub(r'--hostname="(.*)"', f'"{HOSTNAME}"', data)

        # run script for each flag
        for flag in flags:
            # get stdout but stderr goes straight to stdout
            data = subprocess.check_output([os.path.join('extras', flag), data], stderr=sys.stdout).decode('utf-8')

        self.resp_success()

        # write the final output
        self.wfile.write(bytes(data, 'utf-8'))

try:
    print(f'Starting HTTP server at {ARGS.addr}:{ARGS.port}')
    httpd = HTTPServer((ARGS.addr, ARGS.port), MyHandler)
    httpd.serve_forever()
except KeyboardInterrupt:
    print('Quitting..')
    exit(0)

