#!/usr/bin/env python3
#
# host.py - hosts http server for the kickstart files

from http.server import SimpleHTTPRequestHandler
from socketserver import TCPServer

# TODO parse path and then allow adding suffix to files like /@part_aurum/almalinux will add partitioning for aurum to almalinux file
# TODO warn if trying to access wrong files
# TODO list all valid kickstart files

PORT = 8000

try:
    with TCPServer(("0.0.0.0", PORT), SimpleHTTPRequestHandler) as httpd:
        print("Serving at port", PORT)
        httpd.serve_forever()
except KeyboardInterrupt:
    print('Quitting..')
    exit(0)

