#!/usr/bin/env zsh
# shamelessly stolen from
# https://github.com/popstas/zsh-command-time/tree/master
#
# adapted by Sandorex

export ZSH_COMMAND_TIME_EXCLUDE=( vi vim nvim nano emacs micro less man )

_command_time_preexec() {
    # check excluded
    if [[ -n "$ZSH_COMMAND_TIME_EXCLUDE" ]]; then
        cmd="$1"
        for exc ($ZSH_COMMAND_TIME_EXCLUDE) do;
            if [[ "$1" =~ "^$exc" ]]; then
                # echo "command excluded: $exc"
                return
            fi
        done
    fi

    timer=${timer:-$SECONDS}
    ZSH_COMMAND_TIME_MSG=${ZSH_COMMAND_TIME_MSG-"Execution time: %s"}
    ZSH_COMMAND_TIME_COLOR=${ZSH_COMMAND_TIME_COLOR-"blue"}
    export ZSH_COMMAND_TIME=""
}

_command_time_precmd() {
    if [ $timer ]; then
        timer_show=$(($SECONDS - $timer))
        if [ -n "$TTY" ] && [ $timer_show -ge ${ZSH_COMMAND_TIME_MIN_SECONDS:-3} ]; then
            export ZSH_COMMAND_TIME="$timer_show"
            if [ ! -z ${ZSH_COMMAND_TIME_MSG} ]; then
                zsh_command_time
            fi
        fi
        unset timer
    fi
}

zsh_command_time() {
    if [ -n "$ZSH_COMMAND_TIME" ]; then
        # splits up so it shows nicer output like 2h 10s, 3m etc
        local hours="$(( $ZSH_COMMAND_TIME / 3600 ))"
        local minutes="$(( $ZSH_COMMAND_TIME % 3600 / 60))"
        local seconds="$(( $ZSH_COMMAND_TIME % 60 ))"

        timer_show=""
        if [[ "$seconds" -ne 0 ]]; then
            timer_show="$(printf '%ds' "$seconds") $timer_show"
        fi

        if [[ "$minutes" -ne 0 ]]; then
            timer_show="$(printf '%dm' "$minutes") $timer_show"
        fi

        if [[ "$hours" -ne 0 ]]; then
            timer_show="$(printf '%dh' "$hours") $timer_show"
        fi

        print -P "%F{$ZSH_COMMAND_TIME_COLOR}$(printf "${ZSH_COMMAND_TIME_MSG}\n" "%f$timer_show")"
    fi
}

precmd_functions+=(_command_time_precmd)
preexec_functions+=(_command_time_preexec)
