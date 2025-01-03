set -g fish_greeting

# interactive only stuff
if status is-interactive
    alias e="$EDITOR1"
    alias ee="$EDITOR2"
    alias eee="$EDITOR3"

    # use lsd if possible
    if command -v lsd &> /dev/null
        alias ls='lsd -F'
        alias l='lsd -aF'
        alias ll='lsd -alF'
    else
        alias ls='ls -F --color=auto'
        alias l='ls -aF --color=auto'
        alias ll='ls -alFh --color=auto'
    end
end
