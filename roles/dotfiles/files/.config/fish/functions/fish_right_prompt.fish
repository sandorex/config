function fish_right_prompt
    set -l _status $status

    # show execution time in blue
    prompt_execution_time "$(set_color blue)" "$(set_color normal) "

    if test $_status -ne 0
        echo -n (set_color brred)\[ $_status ](set_color normal)\ 
    end

    # dim the pwd so its not that eye catching
    echo (set_color brwhite)(prompt_pwd)(set_color normal)\ 
end
