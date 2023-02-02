# NOTE: intentionally uppercase so i can match the action
Enum Actions {
    PARAMS
    HELP
    INSTALL
    REVERT
}

function Run() {
    Param (
        [Actions]
        $Action = [Actions]::HELP,

        [Switch]
        $UseSymlink = $true
    )

    Write-Host "Running git install $Action $UseSymlink..."
}

#Export-ModuleMember -Function Install

