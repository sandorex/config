from typing import List, Optional, Callable
from pathlib import Path

from . import defs

class Action:
    def __init__(self, text, fn: Callable):
        self.__text = text
        self.__fn = fn
   
    def info(self):
        '''Returns information about the action'''
        return self.__text

    def ask(self) -> bool:
        '''Asks the user should the action be executed'''
        return False # TODO

    def execute(self, *args, **kwargs) -> Optional[Exception]:
        try:
            self.__fn(*args, **kwargs)
        except Exception as ex:
            return ex
        
        return None

class Directory:
    """Class pointing to a directory of a config

    symlink: If none it's what user decides, otherwise forces symlinking or copying if true
    or false respectively
    
    allow_dirty: If disabled the directory in destination will be deleted before copying/linking
    """

    def __init__(self, src, dst, symlink: Optional[bool], allow_dirty: bool):
        self.src = Path(src)
        self.dst = Path(dst)
        self.symlink = symlink
        self.allow_dirty = allow_dirty

    def __repr__(self):
        return f"Dir '{self.src}' symlink={self.symlink} allow_dirty={self.allow_dirty}"

class File:
    def __init__(self, src, dst, template: bool, symlink: Optional[bool]):
        self.src = Path(src)
        self.dst = Path(dst)
        self.template = template
        self.symlink = symlink

    def __repr__(self):
        return f"File '{self.src}' template={self.template} symlink={self.symlink}"

class Config:
    def __init__(self, name: str, file: str, files: List[File], dirs: List[Directory]):
        self.name = name
        self.file = file
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

# builder pattern
class ConfigBuilder:
    def __init__(self, name: str, file: str):
        self.name = name
        self.file = file
        self.dirs: List[Directory] = []
        self.files: List[File] = []

    def finish(self, add_globally=True) -> Config:
        config = Config(self.name, self.file, self.files, self.dirs)
        
        if add_globally:
            defs.CONFIGS.append(config)

        return config

    def add_dir(self, src, dst, *, symlink: Optional[bool]=None, allow_dirty=True) -> 'ConfigBuilder':
        self.dirs.append(Directory(src, dst, symlink))

        return self

    def add_file(self, src, dst, *, template=False, symlink=None) -> 'ConfigBuilder':
        self.files.append(File(src, dst, template, symlink))

        return self

