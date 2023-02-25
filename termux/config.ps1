#!/usr/bin/env pwsh

[CmdletBinding(SupportsShouldProcess)]
Param(
    [Parameter(Mandatory = $true,
        ParameterSetName = 'install')]
    [switch]
    $Install,

    [Parameter(Mandatory = $true,
        ParameterSetName = 'status')]
    [switch]
    $Status,
    
    [Parameter(Mandatory = $true,
        ParameterSetName = 'sync')]
    [switch]
    $Sync
)

$DIR = 'termux'
$SRC = $PSScriptRoot + '/' + $DIR
$DST = $HOME + '/.' + $DIR

If ($Install) {
    Copy-Item -Recurse $SRC $DST
}

If ($Status) {
    diff -s --color=auto $SRC $DST
}

If ($Sync) {
    Copy-Item -Recurse $DST $SRC
}

