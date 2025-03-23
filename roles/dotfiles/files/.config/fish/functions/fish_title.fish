function fish_title
    # show if in arcam container
    if set -q CONTAINER_NAME
        echo -n $CONTAINER_NAME": "
    end

    echo (prompt_pwd --full-length-dirs 2);
end
