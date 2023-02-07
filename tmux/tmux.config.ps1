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

$SRC_DIR = $PSScriptRoot + "/tmux"
$DST_DIR = ($HOME + "/.config/tmux")

# import common functions and things
Import-Module -Force -Name (Resolve-Path -Path ($PSSCriptRoot + "/../.common.psm1"))

Switch ($Action.ToLower()) {
    "help" {
        CHelp $PSCommandPath
    }

    "install" {
        If ($DryRun) {
            Write-Host "Dry run mode, no changes will be made" -ForegroundColor Green
        }

        CIterFiles ($SRC_DIR) | % { Process {
            $src = $_
            $dest = CGetDestination -File $src -Root $SRC_DIR -DestDirectory $DST_DIR
        
            $fargs = @{
                Source = $src
                Destination = $dest
                NoSymlink = $NoSymlink
                DryRun = $DryRun
            }

            CInstall @fargs
        }}
    }

    "diff" {
        CIterFiles ($SRC_DIR) | % { Process {
            $src = $_
            $dest = CGetDestination -File $src -Root $SRC_DIR -DestDirectory $DST_DIR
            
            CDiff $src $dest
        }}
    }

    default {
        Write-Host "Action '$Action' has not been implemented" -ForegroundColor Red
        CHelp $PSCommandPath
        Exit 1
    }
}

