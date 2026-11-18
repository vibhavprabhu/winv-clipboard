#!/bin/sh
# Builds dist/winv_<version>_all.deb. Needs dpkg-deb (any Debian/Ubuntu system).
set -e
ROOT=$(cd "$(dirname "$0")" && pwd)
VERSION=$(sed -n 's/^VERSION = "\(.*\)"/\1/p' "$ROOT/src/winv")
WORK=$(mktemp -d)
PKG="$WORK/winv_${VERSION}_all"
trap 'rm -rf "$WORK"' EXIT

install -Dm755 "$ROOT/src/winv"                   "$PKG/usr/bin/winv"
install -Dm644 "$ROOT/data/winv.desktop"           "$PKG/usr/share/applications/winv.desktop"
install -Dm644 "$ROOT/data/winv-autostart.desktop" "$PKG/etc/xdg/autostart/winv.desktop"
install -Dm644 "$ROOT/README.md"                   "$PKG/usr/share/doc/winv/README.md"

mkdir -p "$PKG/DEBIAN"
cat > "$PKG/DEBIAN/control" <<EOF
Package: winv
Version: $VERSION
Section: utils
Priority: optional
Architecture: all
Depends: python3 (>= 3.6), python3-gi, gir1.2-gtk-3.0, python3-xlib, xdotool, x11-utils
Recommends: fonts-noto-color-emoji
Suggests: ydotool, wtype, fonts-noto-cjk
Maintainer: winv <winv@localhost>
Description: Windows-style (Win+V) clipboard history
 Keeps the last 25 copied texts and images and shows them in a panel
 opened with Super+V. Entries can be pinned, deleted or cleared, and the
 selected entry is pasted straight into the window you were working in.
 Includes a searchable emoji, kaomoji and symbol picker (Super+.).
EOF
printf '/etc/xdg/autostart/winv.desktop\n' > "$PKG/DEBIAN/conffiles"

mkdir -p "$ROOT/dist"
dpkg-deb --build --root-owner-group "$PKG" "$ROOT/dist/" >/dev/null
echo "built $ROOT/dist/winv_${VERSION}_all.deb"
