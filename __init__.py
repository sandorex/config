import pathlib
ROOT = pathlib.Path(__file__).parent.resolve()

import pyconfig
from pyconfig import defs, ConfigBuilder

import importlib

# while this is much better than initial version, i had to do it so that i do
# not need to edit the main files to add new configs, just their own files
#
# looks for any directory containg '.pyconfig' file and then loads it as a
# python module, all other logic should be inside the __init__.py file
for i in ROOT.iterdir():
    if i.is_dir() and i != pyconfig.ROOT:
        if (i / '.pyconfig').is_file():
            # for some reason import_module does not care if its an actual package
            # so it always returns the module even without __init__.py file
            globals()[i.name] = importlib.import_module('.' + i.name, package=__package__)

