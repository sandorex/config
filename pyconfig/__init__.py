import pathlib
ROOT = pathlib.Path(__file__).parent.resolve()

from . import defs
from .config import Directory, File, Config, ConfigBuilder

