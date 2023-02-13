import pathlib
ROOT = pathlib.Path(__file__).parent.resolve()

import pyconfig
from pyconfig import defs, ConfigBuilder

import importlib

# dynamically import all packages that contain '.pyconfig' file
for i in ROOT.iterdir():
    if i.is_dir() and i != pyconfig.ROOT:
        if (i / '.pyconfig').is_file():
            # for some reason import_module does not care if its an actual package
            # so it always returns the module even without __init__.py file
            globals()[i.name] = importlib.import_module('.' + i.name, package=__package__)

