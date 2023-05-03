# this is the progress of my setup script on windows, this is botched together and
# will be split up into smaller chunks like linux scripts are, this will allow for
# for selective

# set dark mode
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# dont hide known extensions
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -PropertyType DWORD -Force

# installed scoop and chocolatey

scoop install git
git config --global credential.helper manager
C:\Users\Sandorex\scoop\apps\git\current\install-context.reg

scoop bucket add nerd-fonts
scoop install FiraCode-NF

# disable sleep on AC
Powercfg /Change standby-timeout-ac 0

# always expand all tray icons NOT VERIFIED
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0 -PropertyType DWORD

# set this up properly
#$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
#$DefaultUsername = "your username"
#$DefaultPassword = "your password"
#Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String
#Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String
#Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String

# disable fast boot
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name HiberbootEnabled -Value 0
