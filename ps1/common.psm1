# this file contains common logic for configs and will be sourced by the scripts if needed

Function ShowHelp() {
    Param(
        [Parameter(Mandatory)]
        [String]
        $File
    )

    Get-Help -Full $File
}

Function IterFiles() {
    <#
        .DESCRIPTION
        Goes over each file/directory in $Source and returns original path,
        and constructed path that preserves path relative to $Source but in $Destination
        Also has IsDirectory property that is true if path is a directory

        All paths returned are absolute!
    #>

	Param (
        [Parameter(Mandatory)]
	    [System.IO.FileInfo]
	    $Source,
	    
        [Parameter(Mandatory)]
	    [System.IO.FileInfo]
	    $Destination
	)

    $src = Resolve-Path -LiteralPath $Source
    $dest = Resolve-Path -LiteralPath $Destination

    # added this cause Get-ChildItem gives garbage output if the path does not exist
    If (!(Test-Path $src)) {
        # TODO: make this an exception or some kind of global error
        Write-Host "Error source does not exist" -ForegroundColor Red
        Exit 1
    }

    # change to location as Resolve-Path can only resolve relative to current dir
    Push-Location $src 

    # -Force makes it find hidden files as well
    $iter = Get-ChildItem . -Recurse -Force
    $result = $iter | % { Process {
        $null = .{
            $srcpath = $_.FullName
            $destpath = Join-Path -Path $dest -ChildPath (Resolve-Path -Relative -LiteralPath $_.FullName)
        }

        @{
            Source = $($srcpath)
            Destination = $($destpath)
            IsDirectory = $_.PSIsContainer
        }
    }}

    Pop-Location

    # delayed output intentionally so that location change wont break it 
    $result
}

Function Install() {
    Param(
        [Parameter(Mandatory)]
        [HashTable]
        $Files,

	    [String]
        $BackupDir = '',

        [Boolean]
        $NoSymlink = $false,

        [Boolean]
        $DryRun = $false
    )

    Foreach ($file in $Files.GetEnumerator()) {
        If (!$NoSymlink) {
            Write-Host "Linking '$($file.Value)' -> '$($file.Name)'" -NoNewline
        } Else {
            Write-Host "Copying '$($file.Name)' => '$($file.Value)'" -NoNewline
        }

        If ((Test-Path $file.Value) -and ($NoBackup.Length -ne 0)) {
            Write-Host " (B)" 
        
            If (!DryRun) {
                Move-Item $file.Value (Join-Path -Path $BackupDir -ChildPath (Spplit-Path -Leaf $file.Value))
            }
        } Else {
            Write-Host
        }

        If (!$DryRun) {
            If ($NoSymlink) {
                Copy-Item $file.Name $file.Value | Out-Null
            } Else {
                New-Item -ItemType "SymbolicLink" -Path $file.Value -Target $file.Name | Out-Null
            }
        }
    }
}
