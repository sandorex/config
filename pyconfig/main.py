#!/usr/bin/env python3

from . import defs

def main():
    # ugly af, imports parent package
    from . import ROOT
    import sys
    sys.path.append(str(ROOT.parent.parent.resolve()))
    __import__(ROOT.parent.resolve().name)

    print('configs found:')
    print(defs.CONFIGS)
    print()

