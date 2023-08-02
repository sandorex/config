#!/usr/bin/env zsh
#
# httts://github.com/sandorex/config
# smart terminal plugin, adds smart features for supporting terminals

## Semantic Zones ##
# separates the prompt from the output of the command so it can be easily
# selected, how is that done depends on the terminal used
#
# supported by: kitty wezterm
_smart_term_precmd_semantic_zones() {
    printf "\033]133;P;k=i\007"
}

_smart_term_preexec_semantic_zones() {
    printf "\033]133;B\007"
    printf "\033]133;C;\007"
}

if [[ -n "$WEZTERM_PANE" ]] || [[ -n "$KITTY_PID" ]]; then
    precmd_functions+=(_smart_term_precmd_semantic_zones)
    preexec_functions+=(_smart_term_preexec_semantic_zones)
fi
