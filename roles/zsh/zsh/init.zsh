#!/usr/bin/env zsh
#
# https://github.com/sandorex/config
# zsh initialization file, ~/.zshrc should link to this file

export SHELLDIR="$HOME/.config/zsh"

source "$AGSHELLDIR/init.sh"

# the rest is only if it's an interactive shell
[[ -o interactive ]] || return

source "$AGSHELLDIR/init-i.sh"

alias reload-shell="source '$SHELLDIR/init.zsh'; compinit"
alias reload-zsh="source '$SHELLDIR/init.zsh'; compinit"

# prevent duplicated hooks on reload
precmd_functions=( )
preexec_functions=( )

## OPTIONS ##
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt extended_history
setopt append_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history 	# share history between all sessions (load history on change)
setopt inc_append_history # incrementally update history (after each command)

setopt no_beep          # no bell
setopt no_clobber       # do not overwrite stuff with redirection
setopt no_match         # error when glob doesnt match anything
setopt no_auto_cd       # no cd into a dir by typing in the path
setopt no_notify        # report about background jobs only before prompt
setopt long_list_jobs   # long format for jobs
setopt globdots         # match dot files with globs implicitly
setopt extendedglob
setopt no_caseglob
setopt no_banghist      # disable !x history expansion
setopt complete_in_word # complete from both ends of a word
setopt complete_aliases # completion for aliases
setopt always_to_end    # move cursor to the end of completed word
setopt auto_list        # list on first tab if ambiguous completion
setopt auto_menu
setopt auto_param_slash # if param is a dir add a trailing slash
setopt interactive_comments
setopt noflowcontrol    # allow Ctrl+Q Ctrl+S to be bound as keybindings

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' completer _complete _ignored _files

fpath=(
    # for some reason these were not in fpath already so no completions were used
    /usr/share/zsh/site-functions/

    "$HOME/.config/zsh/completions"

    "${fpath[@]}"
)

# zsh renamer thingy
autoload -U zmv

# this has to be below options
autoload -Uz compinit bashcompinit

# TODO idk but it seems they canged how it works so now it generates only if it
# thinks it needs to

# generate compinit only every 8 hours
# for _ in "$HOME"/.zcompdump(N.mh+8); do
#     echo "Generating compinit.."
compinit
bashcompinit
# done

compinit -C

# show dotfiles with tab completion
_comp_options+=(globdots)

## PROMPT ##
# simple indicator when running in container
if [[ -v container ]]; then
    _prompt_container_indicator="°"
fi

# prompt expansion https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
PROMPT="[%F{magenta}%n%f@%F{blue}%m%F{${PROMPT_ICON_COLOR}} ${PROMPT_ICON}${_prompt_container_indicator:- }%f] %F{$PROMPT_ICON_COLOR}%(1j.%U.)%%%u%f "

# shows exit code if last command exited with non-zero
RPROMPT="%(?..%F{red}[ %?%  ] %f)%F{243}%27<..<%~%f"

setopt noflowcontrol
source "$SHELLDIR/keybindings.zsh"

## PLUGINS ##

source "$SHELLDIR/plugins/smart-terminal.zsh"
source "$SHELLDIR/plugins/execution-time.zsh"

# load last
source "$SHELLDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# remove duplicates from path just in case
typeset -U path

# aliases must be loaded after compinit because compdef
source "$AGSHELLDIR/aliases.sh"

# list files on dir change
function chpwd() {
    ls # this should use the alias for ls if there is any
}

function precmd() {
    # update the title
    printf "\033]0;%s\007" "$(pwd)"
}

