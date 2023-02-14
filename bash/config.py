#!/usr/bin/env python3
"""Configuration for bash"""

# TODO: make ~/.bashrc symlink to bash/init.bash

from .. import ConfigBuilder

# so just link or copy the bash dir into ~/.config
cfg = ConfigBuilder('bash', __file__, __doc__) \
    .variant('nobashrc') \
    .add('bash/', '~/.config/') \
    .finish() \
    .variant() \
    .add('bashrc', '~/.bashrc') \
    .finish()

