function fish_prompt
    set -l _status $status

    # if there are background jobs draw underline    
    if test (jobs | wc -l) -ne 0
        echo -n (set_color magenta --underline)
    else
        echo -n (set_color magenta)
    end
    
    echo -n (whoami)(set_color normal)@(set_color blue)(prompt_hostname) (set_color $PROMPT_ICON_COLOR_HEX)$PROMPT_ICON(set_color normal)

    # color the arrow in red if exit code is not 0
    if test $_status -ne 0
        echo -n (set_color brred)
    end

    echo ' ~> '(set_color normal)
end
