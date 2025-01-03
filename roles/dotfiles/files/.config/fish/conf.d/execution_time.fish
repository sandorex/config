function execution_time_preexec --on-event fish_preexec
    # reset last
    set -e _execution_time

    # set execution time
    set -g _execution_time_start (date '+%s')
end

function execution_time_postexec --on-event fish_postexec
    set -l end (date '+%s')

    # not defined so quit early
    if not set -q _execution_time_start
        return
    end

    set -g _execution_time (math $end - $_execution_time_start)

    # reset it
    set -e _execution_time_start
end

function prompt_execution_time
    # only do something when more than 10 seconds have passed
    if not set -q _execution_time; or test $_execution_time -lt 10
        return
    end

    set -l hours (math -s 0 $_execution_time / 3600)
    set -l minutes (math -s 0 $_execution_time % 3600 / 60)
    set -l seconds (math -s 0 $_execution_time % 60)

    # construct the string
    set -l output
    if test $hours -ne 0
        set -a output {$hours}h
    end

    if test $minutes -ne 0
        set -a output {$minutes}m
    end

    if test $seconds -ne 0
        set -a output {$seconds}s
    end

    # print prefix if supplied
    if set -q argv[1]
        echo -n $argv[1]
    end

    echo -n $output

    # print suffix
    if set -q argv[2]
        echo -n $argv[2]
    end

    # newline
    echo
end
