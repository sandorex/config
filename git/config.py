#!/usr/bin/env python3
"""Configuration for git

Just has .gitconfig for now
"""

if __name__ == '__main__':
    print('this config is not meant to be executed.')
    exit(1)

from . import ROOT
from .. import ConfigBuilder

ConfigBuilder('git', __file__) \
    .add('.gitconfig', '~/.gitconfig') \
    .add('x/y/z', '~/') \
    .finish()

