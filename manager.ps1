Param (
    [String[]]$Configs,

    [Switch]$Uninstall
)

function Link-All {
    Param (
        [System.IO.FileInfo]$Source,
        [System.IO.FileInfo]$Destination
    )

    $src = Resolve-Path -LiteralPath $Source
    $dest = Resolve-Path -LiteralPath $Destination

    # TODO: test if any of them is not a valid path etc..

    Write-Host "Copying from '$src' to '$dest'"

    Push-Location $src

    $iter = Get-ChildItem . -Recurse
    $iter | % { Process {
        $path = (Resolve-Path -Relative -LiteralPath $_.FullName).ToString().Substring(2)
        $destpath = Join-Path -Path $dest -ChildPath $path

        If ($_.PSIsContainer) {
            Write-Host "Creating directory '$destpath'"
            New-Item -Path $destpath -ItemType "Directory" -Force | Out-Null
        } Else {
            Write-Host "Linking file '$destpath' -> '$_'"
            New-Item -ItemType "SymbolicLink" -Path $destpath -Target $_ -Force | Out-Null
        }
    }}

    Pop-Location
}

If ($Configs.Length -eq 0) {
    Write-Host "List of configs available for installation"
    $iter = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "*.config.ps1") -Recurse
    $iter | % { Process {
        $name = $_.Basename.Replace(".config","")
        Write-Host "  > $name ($_)"
    }}
    
    Exit 0
}

Write-Host "Processing command '?' for configs '$Configs'"
Write-Host

# TODO: ask if user wants to continue

$Configs | % { Process {
    Write-Host "Processing '$_'"

    $script = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "$_.config.ps1") -Recurse -ErrorAction SilentlyContinue)
    
    If ($script.Length -eq 0) {
        Write-Host "Config '$_' has no script!"
        Exit 1
    } ElseIf ($script.Length -gt 1) {
        Write-Host "Config '$_' has more than one config!"
        Exit 1
    }

    Write-Host "Found script '$($script[0])'"
    
    & ($script[0]) 'command?'
}}

