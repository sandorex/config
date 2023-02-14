#!/usr/bin/env python3
"""Configuration for git

Just has .gitconfig for now
"""

from .. import ConfigBuilder

ConfigBuilder('git', __file__, __doc__) \
    .add('.gitconfig', '~/') \
    .finish()

