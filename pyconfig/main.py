#!/usr/bin/env python3

import json

from . import defs

def main():
    # ugly af, imports parent package
    from . import ROOT
    import sys
    sys.path.append(str(ROOT.parent.parent.resolve()))
    __import__(ROOT.parent.resolve().name)

    print(defs.CONFIGS)
    print()
    print('configs found:')
    for cfg in defs.CONFIGS:
        print(cfg.name, cfg.to_json(indent=4))
    #cfg = defs.CONFIGS[0]
    #for dire in cfg.dirs:
    #    print(f"({dire}) {dire.src} -> {dire.dst}")
    #for file in cfg.files:
    #    print(f"({file}) {file.src} -> {file.dst}")
    print()

