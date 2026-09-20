#!/bin/sh
set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q warpinator | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/org.x.Warpinator.desktop
export ICON=/usr/share/icons/hicolor/256x256/apps/org.x.Warpinator.png
export DEPLOY_PYTHON=1

export PATH_MAPPING='
	/usr/share/warpinator:${SHARUN_DIR}/share/warpinator
	/usr/share/locale:${SHARUN_DIR}/share/locale
'

# Deploy dependencies
quick-sharun \
  /usr/bin/warpinator* \
  /usr/lib/warpinator \
  /usr/share/warpinator \
  /usr/lib/libgtk-3.so* \
  /usr/lib/libxapp.so*

# Deploy additional .desktop files
mkdir -p ./AppDir/share/applications
cp -f /etc/xdg/autostart/warpinator-autostart.desktop ./AppDir/share/applications/

# Patch wrapper scripts portably to use AppDir
for bin in ./AppDir/bin/warpinator*; do
  [ -f "$bin" ] || continue
  sed 's|/usr|"$APPDIR"|g' "$bin" >"$bin.tmp" && mv -f "$bin.tmp" "$bin"
  chmod 755 "$bin"
done

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage
quick-sharun --simple-test ./dist/*.AppImage
