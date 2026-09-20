#!/bin/sh
set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/org.x.Warpinator.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/org.x.Warpinator-error-symbolic.svg
export DEPLOY_PYTHON=1

# Deploy dependencies
quick-sharun /usr/bin/warpinator* /usr/lib/warpinator /usr/share/warpinator /usr/lib/libgtk-3.so*

# Deploy additional .desktop files
mkdir -p ./AppDir/share/applications
cp -f /etc/xdg/autostart/warpinator-autostart.desktop ./AppDir/share/applications/

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage
quick-sharun --test ./dist/*.AppImage
