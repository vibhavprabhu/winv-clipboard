#!/bin/sh
# Installs winv on any distro (Debian/Ubuntu users can use the .deb instead).
#   sudo ./install.sh            install
#   sudo ./install.sh --remove   uninstall
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)

if [ "$(id -u)" -ne 0 ]; then
    echo "run as root: sudo $0 $*" >&2
    exit 1
fi

if [ "$1" = "--remove" ]; then
    rm -f /usr/bin/winv /usr/share/applications/winv.desktop /etc/xdg/autostart/winv.desktop
    echo "winv removed. (Each user can run 'winv --remove-hotkey' first to undo the GNOME shortcut.)"
    exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
    apt-get install -y python3-gi gir1.2-gtk-3.0 python3-xlib xdotool x11-utils fonts-noto-color-emoji
elif command -v dnf >/dev/null 2>&1; then
    dnf install -y python3-gobject gtk3 python3-xlib xdotool xprop google-noto-color-emoji-fonts
elif command -v pacman >/dev/null 2>&1; then
    pacman -S --needed --noconfirm python-gobject gtk3 python-xlib xdotool xorg-xprop noto-fonts-emoji
elif command -v zypper >/dev/null 2>&1; then
    zypper --non-interactive install python3-gobject python3-gobject-Gdk typelib-1_0-Gtk-3_0 python3-python-xlib xdotool xprop
else
    echo "Unknown package manager. Install these yourself: Python 3 GObject bindings, GTK 3, python-xlib, xdotool, xprop" >&2
fi

install -Dm755 "$ROOT/src/winv"                   /usr/bin/winv
install -Dm644 "$ROOT/data/winv.desktop"           /usr/share/applications/winv.desktop
install -Dm644 "$ROOT/data/winv-autostart.desktop" /etc/xdg/autostart/winv.desktop

echo
echo "winv installed. Log out and back in, or start it now with:  winv &"
echo "Then press Super+V."
