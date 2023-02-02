Param (
    [System.IO.FileInfo]
    $Source,
    
    [System.IO.FileInfo]
    $Destination
)

$src = Resolve-Path -LiteralPath $Source
$dest = Resolve-Path -LiteralPath $Destination

# TODO: test if any of them is not a valid path etc..

Write-Host "Symlinking from '$src' to '$dest'"

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

