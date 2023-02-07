# this file contains common logic for configs and will be sourced by the scripts if needed

$global:DefaultPrefix = $PSSCriptRoot + "/install"

Function CHelp() {
    Param(
        [Parameter(Mandatory)]
        [String]
        $File
    )

    Get-Help -Full $File
}

Function CDiff() {
    Param(
        [Parameter(Mandatory)]
        [String]
        $File1,

        [Parameter(Mandatory)]
        [String]
        $File2
    )

    # using git diff as it's available on all platforms, especially as this config is on github
    git --no-pager diff --color=auto --no-index $File1 $File2
}

Function CRelativePath() {
    <#
        .DESCRIPTION
        Gets path relative to $Path from $Root, does not check if the path exists or if it's valid
        It works purely on string manipulation
    #>

    Param(
        [Parameter(Mandatory)]
	    [String]
        $Path,

        [Parameter(Mandatory)]
	    [String]
        $Root
    )

    If ($Path.StartsWith($Root)) {
        Write-Output $Path.Substring($Root.Length)
    }
}

Function CGetDestination() {
    <#
        .DESCRIPTION
        The name of this function is horrible
        It gets a relative path of $File relative to $Root and adds it to $DestinationDirectory
    #>

    Param(
        [Parameter(Mandatory)]
	    [String]
        $File,

        [Parameter(Mandatory)]
	    [String]
        $Root,

        [Parameter(Mandatory)]
        [String]
        $DestDirectory
    )

    $file = Resolve-Path -LiteralPath $File
    $root = Resolve-Path -LiteralPath $Root

    $path = CRelativePath $file $root
    If ($path.ToString().Length -gt 0) {
        Write-Output (Join-Path -Path $DestDirectory -ChildPath $path)
    }
}

Function CIterFiles() {
	Param (
        [Parameter(Mandatory)]
	    [System.IO.FileInfo]
	    $Directory
    )
    
    # It does not exist so just abort, Get-ChildItem gives random output if the path does not exist
    If (!(Test-Path $Directory)) {
        return
    }

    Get-ChildItem $Directory -Recurse -Force
}

Function CInstall() {
    Param(
        [Parameter(Mandatory)]
	    [System.IO.FileInfo]
        $Source,

        [Parameter(Mandatory)]
	    [System.IO.FileInfo]
        $Destination,

	    [String]
        $BackupDir = '',

        [Boolean]
        $NoSymlink = $false,

        [Boolean]
        $DryRun = $false
    )

    If ((Test-Path $Destination) -and ($BackupDir.Length -ne 0)) {
        Write-Output "Backing up '$Destination'" 
    
        # TODO: the path needs to be preserved again fully
    }

    If (!$NoSymlink) {
        Write-Output "Linking '$Destination' -> '$Source'"
    } Else {
        Write-Output "Copying '$Source' => '$Destination'"
    }

    If (!$DryRun) {
        # create the directory if it does not exist
        New-Item -Force -ItemType "Directory" -Path (Split-Path $Destination) | Out-Null

        If ($NoSymlink) {
            Copy-Item $Source $Destination | Out-Null
        } Else {
            New-Item -ItemType "SymbolicLink" -Path $Destination -Target $Source | Out-Null
        }
    }
}

