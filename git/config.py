#!/usr/bin/env python3
"""Configuration for git

Just has .gitconfig for now
"""

from .. import ConfigBuilder

ConfigBuilder(__file__, 'git', __doc__) \
    .add('.gitconfig', '~/') \
    .save()

