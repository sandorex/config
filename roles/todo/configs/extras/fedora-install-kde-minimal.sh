#!/usr/bin/env bash
#
# fedora-install-kde-minimal.sh - installs filtered kde desktop from minimal

if ! command -v dnf &>/dev/null; then
    echo "Dumbass you need dnf to use this"
    exit 1
fi

# rerun as sudo
if [[ $EUID -ne 0 ]]; then
    exec sudo "$SHELL" "$0"
fi

# this is not strictly necessary but i want to be sure no bloat is added
# save output from `dnf group info kde-desktop | tail -n +2` when it changes
GROUP_KDE="$(cat <<EOF
Group: KDE (K Desktop Environment)
 Description: KDE is a powerful graphical user interface which includes a panel, desktop, system icons, and a graphical file manager.
 Mandatory Packages:
   plasma-desktop
   plasma-workspace
   plasma-workspace-wallpapers
   qt5-qtbase-gui
   sddm
   sddm-breeze
   sddm-kcm
 Default Packages:
   NetworkManager-config-connectivity-fedora
   PackageKit-command-not-found
   abrt-desktop
   adwaita-gtk2-theme
   akregator
   bluedevil
   breeze-icon-theme
   colord-kde
   cups-pk-helper
   dnfdragora
   dolphin
   ffmpegthumbs
   firewall-config
   flatpak-kcm
   fprintd-pam
   glibc-all-langpacks
   gnome-keyring-pam
   gwenview
   initial-setup-gui
   kaddressbook
   kamera
   kcalc
   kcharselect
   kde-connect
   kde-gtk-config
   kde-partitionmanager
   kde-print-manager
   kde-settings-pulseaudio
   kdegraphics-thumbnailers
   kdeplasma-addons
   kdialog
   kdnssd
   keditbookmarks
   kf5-akonadi-server
   kf5-akonadi-server-mysql
   kf5-baloo-file
   kf5-kipi-plugins
   kfind
   kgpg
   khelpcenter
   khotkeys
   kinfocenter
   kio-admin
   kio-gdrive
   kmag
   kmail
   kmenuedit
   kmousetool
   kmouth
   konsole5
   kontact
   korganizer
   kscreen
   kscreenlocker
   ksshaskpass
   kwalletmanager5
   kwebkitpart
   kwin
   kwrite
   libappindicator-gtk3
   okular
   phonon-qt5-backend-gstreamer
   pinentry-qt
   plasma-breeze
   plasma-desktop-doc
   plasma-discover
   plasma-discover-notifier
   plasma-disks
   plasma-drkonqi
   plasma-nm
   plasma-nm-l2tp
   plasma-nm-openconnect
   plasma-nm-openswan
   plasma-nm-openvpn
   plasma-nm-pptp
   plasma-nm-vpnc
   plasma-pa
   plasma-systemmonitor
   plasma-thunderbolt
   plasma-vault
   fuck-no
   plasma-welcome
   plasma-workspace-geolocation
   plasma-workspace-x11
   polkit-kde
   qt5-qtdeclarative
   spectacle
   systemd-oomd-defaults
   udisks2
   xorg-x11-drv-libinput
 Optional Packages:
   kaffeine
   plasma-pk-updates
 Conditional Packages:
   qt-at-spi
EOF
)"

PACKAGE_BLACKLIST=(
    PackageKit
    'PackageKit-command-not-found'
    kaddressbook
    kamera
    kmail
    kmousetool
    kmouth
    kontact
    korganizer
    'systemd-oomd-defaults'
    akregator # rss reader
)

log_info() { echo "$(tput setaf 4)$*$(tput sgr0)"; }
log_err() { echo "$(tput setaf 1)$*$(tput sgr0)"; }

if ! diff_output="$(diff --color=always -U2 --label EXPECTED <(printf '%s\n' "$GROUP_KDE") --label NOW <(dnf group info kde-desktop | tail -n +2))"; then
    echo
    log_err "$(cat <<EOF
 ____    _    _   _  ____ _____ ____  _
|  _ \  / \  | \ | |/ ___| ____|  _ \| |
| | | |/ _ \ |  \| | |  _|  _| | |_) | |
| |_| / ___ \| |\  | |_| | |___|  _ <|_|
|____/_/   \_\_| \_|\____|_____|_| \_(_)
EOF
)"
    echo
    log_err "The group @kde-desktop is different than when this script was written, this may or may not break everything"
    echo
    echo "The changes:"
    printf "%s\n" "$diff_output"
    echo

    # shellcheck disable=SC2162
    read -p "Do you still want to proceed? (y/N) " yn
    case "$yn" in
        [Yy]|[Yy]es)
            ;;
        *)
            echo "Aborted.."
            exit 1
            ;;
    esac
fi

# intentionally did not add --assumeyes to ask the user before proceeding
dnf remove "${PACKAGE_BLACKLIST[@]}"

