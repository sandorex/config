## Config

**These are dotfiles, there are many like it but these are mine.**

Cross platform dotfiles, Linux + WSL + Windows

### Main Software
- Neovim, the main editor
- Nano, the backup editor for simple things, it has it's own config actually!
- ZSH, my shell of choice as it's easy to customize and quite pleasing to use
- Bash, backup shell, scripting language used extensively and well it's default on literally everything
- TMUX, currently my terminal multiplexer of choice, may change in the future
- WezTerm, my current terminal of choice, supports both linux and windows and has extensive configuration in lua

### Management
Installation is done by linking it using bash scripts, to push any changes i use `git add --patch` to select what i want to save

### Why So Complex?
This configuration evolved (and is still evolving) in span of couple of months,
i started with need to use a editor over ssh and ended up with bunch of configuration
that are i think kinda cool, most of things are commented too!

### Bootstrap

```
$ curl -s https://raw.githubusercontent.com/sandorex/config/master/bootstrap/bootstrap.sh | bash -s
```

#### Already Cloned?

If you already cloned the git repository run `bootstrap/git-modules.sh` to download the required modules

### Installation

To install any of the modules just run the `install.sh` file contained within, some may require additional parameters.
