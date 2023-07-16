# Theming Setup
Install the themes in `dracula-debian`

## GTK Theming
This will make the GTK apps look the same (even the ones that run as root like timeshift)

Install `https://github.com/dracula/gtk` to `/usr/share/themes` and set it in `Appearance > Application Style > Configure GNOME/GTK Application Style

## Plymouth
On debian install `plymouth-themes` and set it using `sudo plymouth-set-default-theme -R spinner`

