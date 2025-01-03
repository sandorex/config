function fish_prompt
    set -l _status $status
    
    echo -n (set_color magenta)(whoami)(set_color normal)@(set_color blue)(prompt_hostname) (set_color $PROMPT_ICON_COLOR_HEX)$PROMPT_ICON(set_color normal)

    # color the arrow in red if exit code is not 0
    if test $_status -ne 0
        echo -n (set_color brred)
    end

    echo ' ~> '(set_color normal)
end
