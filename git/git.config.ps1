#!/bin/pwsh

<#
    .DESCRIPTION
    Manages configuration for git

    .PARAMETER Action
    Which acton to perform, help, install, revert, diff

    .PARAMETER NoSymlink
    If true all files will be copied instead of linked

    .PARAMETER Write
    If false no changes will be made to the filesystem, dry run essentially

    .PARAMETER Prefix
    Install path prefix
#>

[CmdletBinding(PositionalBinding=$false)]
Param(
    [Switch]
    $NoSymlink,

    [Switch]
    $Write,

    [Parameter(Mandatory)]
    [String]
    $Action,

    [String]
    $Prefix
)

# import common functions and things
Import-Module -Force -Name (Resolve-Path -Path ($PSSCriptRoot + "/../.common.psm1"))

# set default prefix if not provided
If (!$PSBoundParameters.ContainsKey("Prefix")) {
    $Prefix = $global:DefaultPrefix
}

$FILES = @{
    ($PSScriptRoot + "/.gitconfig") = ($Prefix + $HOME + "/.gitconfig")
}

Switch ($Action.ToLower()) {
    "help" {
        CHelp $PSCommandPath
        Exit 0
    }

    "install" {
        If (!$Write) {
            Write-Host "Dry run mode, no changes will be made" -ForegroundColor Green
        }

        Foreach ($file in $FILES.GetEnumerator()) {
            $fargs = @{
                Source = $file.Name
                Destination = $file.Value
                NoSymlink = $NoSymlink
                DryRun = !$Write
            }

            CInstall @fargs
        }
    }

    "diff" {
        CDiff $FILES
    }

    default {
        Write-Host "Action '$Action' has not been implemented" -ForegroundColor Red
        CHelp $PSCommandPath
        Exit 1
    }
}

