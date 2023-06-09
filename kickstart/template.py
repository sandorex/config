#!/usr/bin/env python3
#
# template.py - templates a kickstart config like VENTOY and optionally host it

import argparse
import re

from http.server import HTTPServer, BaseHTTPRequestHandler, SimpleHTTPRequestHandler

parser = argparse.ArgumentParser(description="Emulate VENTOY auto_install and template kickstart configuration, can optionally serve it over HTTP too")
parser.add_argument('-s', '--serve', action='store_true', help='Serve the file as HTTP server (defaults to true if no file is provided)')
parser.add_argument('-p', '--port', type=int, help='Port for the HTTP server', default=8000)
parser.add_argument('-a', '--addr', help='Address for the HTTP server (defaults to 0.0.0.0)', default='0.0.0.0')
parser.add_argument('file', nargs='?', help='File to to template (and optionally serve)')
parser.add_argument('vars', nargs='*', help='Values for variables, missing variables will be asked on runtime (syntax var=value)')

args = parser.parse_args()

# parse preset variables
var_preset = {}
for i in args.vars:
    # allow empty value but not empty variable name
    m = re.match('(.+)=(.*)', i)
    if not m:
        print(f"Invalid var '{i}'")
        exit(1)

    var_preset[m.group(1)] = m.group(2)

def serve(file=None):
    class CustomHandler(BaseHTTPRequestHandler):
        def do_GET(self):
            # always return the file
            self.wfile.write(bytes(file, 'utf-8'))
            self.send_response(200)
            self.end_headers()

    if file:
        handler = CustomHandler
    else:
        handler = SimpleHTTPRequestHandler

    try:
        print(f'Starting HTTP server at {args.addr}:{args.port}')
        httpd = HTTPServer((args.addr, args.port), handler)
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('Quitting..')
        exit(0)

if args.file:
    try:
        with open(args.file, 'r') as f:
            data = f.read()
    except FileNotFoundError:
        print(f"File could not be found '{args.file}'")
        exit(1)

    # find all vars
    for p in re.finditer(r'\$\$([A-Za-z_0-9]+)\$\$', data):
        name = p.group(1)
        span = p.span(0)

        try:
            value = var_preset[name]
        except KeyError:
            value = input(f"Enter value for variable '{name}': ")

        data = data[:span[0]] + value + data[span[1]:]

    if args.serve:
        # serve the file
        serve(data)
    else:
        print()
        print('---- TEMPLATED OUTPUT ----')
        print(data)
        print('---- TEMPLATED OUTPUT ----')
else:
    # serve everything always
    serve()

