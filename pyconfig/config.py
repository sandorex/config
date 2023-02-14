import os
import json

from typing import List, Optional, Callable, Union
from pathlib import Path

from . import defs

def is_dir_path(path: str) -> bool:
    '''Checks the string path if it points to a file or directory (ends with the `os.sep`)'''
    return path.endswith(os.sep) or path.replace(os.sep, '') == ''

class Action:
    """Basically stores a function call with its parameters and text of what it
    does so it can all be listed to the user, and if need be user can intervene
    if something fails"""

    def __init__(self, text, fn: Callable, *args, **kwargs):
        self.__text = text
        self.__fn = fn
        self.__args = args
        self.__kwargs = kwargs
   
    def __eq__(self, obj):
        if not isinstance(obj, Action):
            raise RuntimeError(f"Action cannot be compared with '{type(obj)}'")

        # its equal if the function and arguments are the same, basically if it
        # does the same thing
        return self.__fn == obj.__fn \
            and self.__args == obj.__args \
            and self.__kwargs == obj.__kwargs

    def info(self):
        '''Returns information about the action'''
        return self.__text

    def ask(self) -> bool:
        '''Asks the user should the action be executed'''
        return False # TODO

    def execute(self) -> Optional[Exception]:
        try:
            self.__fn(*self.__args, *args, **self.__kwargs, **kwargs)
        except Exception as ex:
            return ex
        
        return None

class Directory:
    """Class pointing to a directory of a config

    symlink: If none it's what user decides, otherwise forces symlinking or copying if true
    or false respectively
    
    allow_dirty: If disabled the directory in destination will be deleted before copying/linking
    """

    def __init__(self, src, dst, *, symlink: Optional[bool], allow_dirty: bool):
        self.src = Path(src)
        self.dst = Path(dst)
        self.symlink = symlink
        self.allow_dirty = allow_dirty

    def __repr__(self):
        return f"Dir '{self.src}/' symlink={self.symlink} allow_dirty={self.allow_dirty}"

class File:
    def __init__(self, src, dst, *, template: bool, symlink: Optional[bool]):
        self.src = Path(src)
        self.dst = Path(dst)
        self.template = template
        self.symlink = symlink

    def __repr__(self):
        return f"File '{self.src}' template={self.template} symlink={self.symlink}"

class Config:
    def __init__(self, name: str, file: str, docs: str, files: List[File], dirs: List[Directory]):
        self.name = name
        self.file = file
        self.docs = docs
        self.files = files
        self.dirs = dirs

    def __add__(self, x):
        if isinstance(x, File):
            self.files.append(x)
        elif isinstance(x, File):
            self.dirs.append(x)
        elif isinstance(x, Config):
            self.files.extend(x.files)
            self.dirs.extend(x.dirs)
        else:
            raise Exception(f"Config cannot be added together with type '{type(x)}'")
    
    def __repr__(self):
        return f"Config '{self.name}' len(files)={len(self.files)} len(dirs)={len(self.dirs)} ({self.file})"

    def to_json(self, **kwargs):
        def serialize(obj, **kwargs):
            try:
                return obj.__dict__
            except AttributeError:
                return str(obj)

        return json.dumps(self.__dict__, default=serialize, **kwargs)

# builder pattern
class ConfigBuilder:
    # TODO: try using inspect module to get __file__    
    def __init__(self, file: str, name='', docs=''):
        self.file = file
        self.name = name
        self.docs = docs
        self.dirs: List[Directory] = []
        self.files: List[File] = []
        
        self.root = Path(file).parent.resolve()

    def __call__(self, name: str, docs='') -> 'ConfigBuilder':
        builder = ConfigBuilder(self.file)
        builder.name = name
        builder.docs = docs
        builder.dirs = self.dirs[:]
        builder.files = self.files[:]

        return builder

    def save(self) -> 'ConfigBuilder':
        cfg = Config(self.name, self.file, self.docs, self.files, self.dirs)

        defs.CONFIGS.append(cfg)

        return self

    def fork(self, name, docs=None) -> 'ConfigBuilder':
        '''Makes a variant of the config with same files/dirs'''
        cfg = ConfigBuilder(name, self.file, docs if docs else self.docs)

        # attempt at copying instead of referencing
        cfg.dirs = self.dirs[:]
        cfg.files = self.files[:]
        
        return cfg

    def merge(self, cfg: 'ConfigBuilder') -> 'ConfigBuilder':
        self.dirs.extend(cfg.dirs)
        self.files.extend(cfg.files)

    def add(self, src: str, dst: str, *, preserve_path: Optional[Union[Path, str]]=None, template=False, symlink=None, allow_dirty=True) -> 'ConfigBuilder':
        src_is_dir = is_dir_path(src)
        dst_is_dir = is_dir_path(dst)

        # ensure the arguments are Path objects and expand home
        src = Path(src).expanduser()
        dst = Path(dst).expanduser()

        # if source is relative make it absolute
        if not src.is_absolute():
            src = self.root / src

        # do not accept source that is not in root of the config
        if not self.root in src.parents:
            raise RuntimeError(f"Source is outside config directory '{self.root}'")

        # if dst does not have a leading slash then just move source there
        # otherwise move it into the directory, preserve path if enabled
        if not dst_is_dir:
            if not preserve_path is None:
                raise RuntimeError(f"Preserve path cannot work if destination points to a file")
        else:
            # support relative preserve root too
            if not preserve_path is None:
                preserve_path = Path(preserve_path).expanduser()
                if not preserve_path.is_absolute():
                    preserve_path = self.root / preserve_path

                dst = dst / src.relative_to(preserve_path)
            else:
                dst = dst / src.name

        if src_is_dir:
            # source is a directory

            if template:
                raise RuntimeError(f"Directory cannot be templated")

            self.dirs.append(Directory(src, dst, symlink=symlink, allow_dirty=allow_dirty))
        else:
            # source is a file
            
            self.files.append(File(src, dst, symlink=symlink, template=template))
        
        return self

    #def add_glob(self, src_glob: str, dst, exclude_glob='', *, preserve_path=True)

# this is dumb hoe do i get destination if i add them likr this
#    def add_glob(self, glob: str, exclude='', *, symlink=None):
#        
#        files = self.root.glob(glob)
#        
#        for file in files:
#            if file.match(exclude)
        #files = [x for x in self.root.glob(glob) if not x.match(exclude)]

# TODO add add function with globbing, filters and shit

