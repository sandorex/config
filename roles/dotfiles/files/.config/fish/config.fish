set -g fish_greeting

# interactive only stuff
if status is-interactive
    alias e="$EDITOR1"
    alias ee="$EDITOR2"
    alias eee="$EDITOR3"

    # use lsd if possible
    if command -v lsd &> /dev/null
        alias ls='lsd -F'
        alias lls='lsd -lF'
        alias l='lsd -aF'
        alias ll='lsd -alF'
    else
        alias ls='ls -F --color=auto'
        alias lls='ls -lF --color=auto'
        alias l='ls -aF --color=auto'
        alias ll='ls -alFh --color=auto'
    end

    # make arrow up/down act like all the other shells
    bind \e\[A 'up-or-prefix-search'
    bind \e\[B 'down-or-prefix-search'
    bind \e\[1\;5A 'up-or-search'
    bind \e\[1\;5B 'down-or-search'

    bind \cS 'fish_commandline_prepend sudo'
end
