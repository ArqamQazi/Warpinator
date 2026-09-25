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
export DEPLOY_GTK=1

export PATH_MAPPING='
	/usr/lib/warpinator:${SHARUN_DIR}/lib/warpinator
	/usr/share/warpinator:${SHARUN_DIR}/share/warpinator
	/usr/lib/girepository-1.0:${SHARUN_DIR}/lib/girepository-1.0
	/usr/share/locale:${SHARUN_DIR}/share/locale
'

# Deploy dependencies
quick-sharun \
	/usr/bin/warpinator*      \
	/usr/lib/warpinator       \
	/usr/share/warpinator     \
	/usr/share/glib-2.0/schemas \
	/usr/lib/libgtk-3.so*     \
	/usr/lib/libxapp.so*      \
	/usr/lib/libgirepository-1.0.so* \
	/usr/lib/libre2.so*       \
	/usr/lib/libcares.so*     \
	/usr/lib/libsodium.so*    \
	/usr/lib/libprotobuf.so*

# Deploy additional .desktop files
mkdir -p ./AppDir/share/applications
cp -f /etc/xdg/autostart/warpinator-autostart.desktop ./AppDir/share/applications/

# Relocate wrapper scripts to use bundled lib and python3
cat <<'EOF' > ./AppDir/bin/warpinator
#!/bin/sh
APPDIR="${APPDIR:-$(cd "${0%/*}/.." && pwd)}"
export WARPINATOR_PATH="$APPDIR/lib/warpinator"
exec python3 "$WARPINATOR_PATH/warpinator-launch.py" "$@"
EOF
chmod 755 ./AppDir/bin/warpinator

cat <<'EOF' > ./AppDir/bin/warpinator-send
#!/bin/sh
APPDIR="${APPDIR:-$(cd "${0%/*}/.." && pwd)}"
export WARPINATOR_PATH="$APPDIR/lib/warpinator"
exec python3 "$WARPINATOR_PATH/warpinator-send.py" "$@"
EOF
chmod 755 ./AppDir/bin/warpinator-send

# Compile GSettings schemas for Warpinator and XApp
glib-compile-schemas ./AppDir/share/glib-2.0/schemas

# Ensure PyGObject finds the bundled typelibs
echo 'GI_TYPELIB_PATH=${SHARUN_DIR}/lib/girepository-1.0:${GI_TYPELIB_PATH}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage
quick-sharun --simple-test ./dist/*.AppImage
