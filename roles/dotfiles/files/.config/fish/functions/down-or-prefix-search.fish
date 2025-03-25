function down-or-prefix-search --description 'Search back or move cursor down 1 line'
    # If we are already in search mode, continue
    if commandline --search-mode
        commandline -f history-prefix-search-forward
        return
    end
    # If we are navigating the pager, then up always navigates
    if commandline --paging-mode
        commandline -f down-line
        return
    end
    # We are not already in search mode.
    # If we are on the top line, start search mode,
    # otherwise move up
    set -l lineno (commandline -L)
    switch $lineno
        case 1
            commandline -f history-prefix-search-forward
        case '*'
            commandline -f down-line
    end
end
