# bash file for tmux aliases and commands
alias lses='tmux list-session'

function ses() {
    tmux new -A -s "${1:-$USER}"
}

function kses() {
    tmux kill-session -t "${1:-$USER}"
}

if [[ -n "$TMUX" ]]; then
    # prevents me from destroying the session all the goddamn time
    alias exit='tmux detach'
    alias detach='tmux detach'
fi
