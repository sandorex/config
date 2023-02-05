<#
    .DESCRIPTION
    Manages configuration for tmux

    .PARAMETER Action
    Which acton to perform, help, install, revert, diff

    .PARAMETER NoSymlink
    If true all files will be copied instead of linked

    .PARAMETER DryRun
    If true no changes will be made to the system, used for debugging
#>

Param(
    [Switch]
    $NoSymlink,

    [Switch]
    $DryRun,

    [String]
    $Action = "help"
)

#$FILES = @{
#    ($PSScriptRoot + "/.gitconfig") = ($HOME + "/.gitconfig")
#}

# import common functions and things
Import-Module -Force -Name (Resolve-Path -Path ($PSSCriptRoot + "/../ps1/common.psm1"))

Switch ($Action.ToLower()) {
    "help" {
        ShowHelp $PSCommandPath
        Exit 0
    }

    "install" {
        If ($DryRun) {
            Write-Host "Dry run mode, no changes will be made" -ForegroundColor Green
        }

        $fargs = @{
            Files = $FILES
            NoSymlink = $NoSymlink
            DryRun = $DryRun
        }

        Install @fargs
    }

    "diff" {
        # TODO: make this into a function too as this is a common usecase
        # with configs, many are in their own directory
        $files = IterFiles ($PSScriptRoot + "/tmux") ($HOME + "/.config/tmux")
        $files | % { Process {
            If (!$_.IsDirectory -and (Test-Path $_.Destination)) {
                ShowDiff @{ $_.Source = $_.Destination }
            }
        }}
    }

    default {
        Write-Host "Action '$Action' has not been implemented" -ForegroundColor Red
        ShowHelp $PSCommandPath
        Exit 1
    }
}

