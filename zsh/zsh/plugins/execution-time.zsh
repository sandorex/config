#!/usr/bin/env zsh
# original taken from
# https://github.com/popstas/zsh-command-time/tree/master
#
# rewritten by Sandorex
#
# this will probably clash if any other plugin adds to RPROMPT as well

_command_time_preexec() {
    _command_time_timer=${_command_time_timer:-$SECONDS}
    _command_time_elapsed=''
}

_command_time_precmd() {
    if [[ $_command_time_timer ]]; then
        local elapsed_seconds=$(($SECONDS - $_command_time_timer))
        if [[ -n "$TTY" ]] && [[ $elapsed_seconds -ge ${ZSH_COMMAND_TIME_MINIMUM_SECONDS:-10} ]]; then
            # split it up so its human readable output like '2h 10s', '3m' etc
            local hours="$(( $elapsed_seconds / 3600 ))"
            local minutes="$(( $elapsed_seconds % 3600 / 60))"
            local seconds="$(( $elapsed_seconds % 60 ))"

            local formatted_time=""
            if [[ "$seconds" -ne 0 ]]; then
                formatted_time="$(printf '%ds' "$seconds") $formatted_time"
            fi

            if [[ "$minutes" -ne 0 ]]; then
                formatted_time="$(printf '%dm' "$minutes") $formatted_time"
            fi

            if [[ "$hours" -ne 0 ]]; then
                formatted_time="$(printf '%dh' "$hours") $formatted_time"
            fi

            # add the color
            _command_time_elapsed="%F{${ZSH_COMMAND_TIME_COLOR:-blue}}${formatted_time:-???}%f"
        fi

        unset _command_time_timer
    fi

    # prepend to existing RPROMPT
    export RPROMPT="${_command_time_elapsed}${_command_tme_original_rprompt}"
}

_command_tme_original_rprompt="$RPOMPT"
precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)

