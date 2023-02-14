#!/usr/bin/env python3
"""Configuration for bash but without bashrc, appends `source ~/.config/bash/bash.init` to ~/.bashrc, allows you to use the distro defaults and your own config without much fuss

<@>

Configuration for bash, replaces bashrc with shim file that only runs `source ~/.config/bash/init.bash`
Do note that the bashrc file is always copied cause it does not need changing or updating but provides a file to clutter when scripts/programs installed need to source their own auto completion or whatever

"""

from .. import ConfigBuilder

docs = __doc__.split('<@>')

ConfigBuilder(__file__) \
    ('bash.nobashrc', docs[0]) \
    .add('bash/', '~/.config/') \
    .save() \
    ('bash', docs[1]) \
    .add('bashrc', '~/.bashrc', symlink=False) \
    .save()

