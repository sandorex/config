#!/usr/bin/env pwsh

<#
    .DESCRIPTION
    Manages configuration for git

    .PARAMETER Action
    Which acton to perform, help, install, revert, diff

    .PARAMETER NoSymlink
    If true all files will be copied instead of linked

    .PARAMETER DryRun
    If true no changes will be made to the system, used for debugging

    .PARAMETER Overlay
    If true .bashrc will be modified to load bash config instead
    replacing it, so original distro configuration will be left untouched
    but probably will be overriden by the config itself

    .PARAMETER HomePath
    Path to home directory, usually just set to home directory but can be used
    to install config elsewhere
#>

[CmdletBinding(PositionalBinding=$false)]
Param(
    [Switch]
    $NoSymlink,

    [Switch]
    $DryRun,

    [Switch]
    $Overlay,

    [Parameter(Mandatory)]
    [String]
    $Action,

    [Parameter(Mandatory)]
    [String]
    $HomePath
)

$SRC_DIR = $PSScriptRoot + "/bash"
$DST_DIR = $HomePath + "/.config/bash"

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
   
        If ($Overlay) {
            Write-Host "Adding initialization code to bashrc file"   
            
            # load the init if it exits
            If (!$DryRun) {
                "[[ -f ~/.config/bash/init.bash ]] && \. ~/.config/bash/init.bash" >> ($HOME + "/.bashrc")
            }
        } Else {
            $fargs = @{
                Source = ($PSScriptRoot + "/.bashrc") 
                Destination = ($HOME + "/.bashrc")
                NoSymlink = $NoSymlink
                DryRun = $DryRun
            }

            CInstall @fargs
        }
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

