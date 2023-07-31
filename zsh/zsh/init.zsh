#!/usr/bin/env zsh
#
# init.zsh - the actual initialization of zsh

export SHELLDIR="$HOME/.config/zsh"

source "${AGSHELLDIR:-$HOME/.config/shell}/non-interactive.sh"

# the rest is only if it's an interactive shell
[[ -o interactive ]] || return

source "$AGSHELLDIR/interactive-pre.sh"

alias reload-shell='source ~/.zshrc; compinit'
alias reload-zsh='source ~/.zshrc; compinit'

# set default color for the prompt
# allows for distinct color for each container / environment
if [[ -z "$PROMPT_COLOR" ]]; then
    # make container default to gray
    if [[ -n "$container" ]]; then
        PROMPT_COLOR='gray'
    else
        # otherwise green as this is most likely the main system
        PROMPT_COLOR='green'
    fi
fi

# prompt expansion https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
PROMPT="%F{$PROMPT_COLOR}%(1j.%B.)%%%b%f "

# shows exit code if last command exited with non-zero
RPROMPT='%(?..%F{red}[ %?%  ]%f )'

# list files on dir change but use lsd if available
if command -v lsd &>/dev/null; then
    chpwd() {
        lsd -F
    }
else
    chpwd() {
        ls --color=auto -F
    }
fi

# TODO move these wezterm specific escapes to separate plugin that uses
# precmd_functions, preexec_functions
precmd() {
    # wezterm semantic zone
    [[ -n "$WEZTERM_PANE" ]] && printf "\033]133;P;k=i\007"

    # update the title
    printf "\033]0;%s\007" "$(pwd)"
}

if [[ -n "$WEZTERM_PANE" ]]; then
    preexec() {
        # wezterm semantic zone so you can easily select command output
        printf "\033]133;B\007"
        printf "\033]133;C;\007"
    }
fi

## OPTIONS ##
HISTFILE=~/.zhistory
HISTSIZE=SAVEHIST=10000
setopt extended_history append_history hist_ignore_dups hist_ignore_space

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
setopt always_to_end    # move cursor to the end of completed word
setopt auto_list        # list on first tab if ambiguous completion
setopt auto_menu
setopt auto_param_slash # if param is a dir add a trailing slash
setopt interactive_comments

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

# generate compinit only every 8 hours
for _ in "$HOME"/.zcompdump(N.mh+8); do
    compinit
    bashcompinit
done

compinit -C

# show dotfiles with tab completion
_comp_options+=(globdots)

source "$SHELLDIR/keybindings.zsh"
source "$AGSHELLDIR/interactive-post.sh"

# zsh compdef for scripts # TODO MOVE ELSEWHERE
compdef cgit=git

# include execution time plugin
source "$SHELLDIR/plugins/execution-time.zsh"

# exclude editor and file manager macros too
ZSH_COMMAND_TIME_EXCLUDE+=( 'e' 'f' )

# syntax highlighting
# HAS TO BE LOADED LAST!
source "$SHELLDIR"/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# remove duplicates from path just in case
typeset -U path

# startup apps and stuff
"$AGSHELLDIR"/init.sh

