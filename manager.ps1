Param (
    [String]
    $Config
)

# list all configs
If ($Config.Length -eq 0) {
    Write-Host "List of configs available"
    $iter = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "*.config.ps1") -Recurse
    $iter | % { Process {
        $name = $_.Basename.Replace(".config","")
        Write-Host "  > $name ($_)"
    }}
    
    Exit 0
}

# TODO: ask if user wants to continue

$script = @(Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath "$Config.config.ps1") -Recurse -ErrorAction SilentlyContinue)

If ($script.Length -eq 0) {
    Write-Host "Error config '$Config' has no script" -ForegroundColor Red
    Exit 1
} ElseIf ($script.Length -gt 1) {
    Write-Host "Error config '$Config' has more than one script:" -ForegroundColor Red
    Foreach ($file in $script) {
        Write-Host "  - '$file'"
    }
    Write-Host
    
    Exit 1
}

function TestConfig() {
    Write-Host "Hello"
}

& ($script[0]) @args

