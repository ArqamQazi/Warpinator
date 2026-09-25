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
	/usr/lib/libprotobuf.so*  \
	/usr/lib/libabsl_*.so*

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

# Guarantee complete transitive dependency closure for C extensions (e.g. grpcio, cygrpc)
while :; do
	new_libs=0
	for elf in $(find ./AppDir/lib ./AppDir/bin -type f \( -name '*.so*' -o -perm /111 \)); do
		for dep in $(ldd "$elf" 2>/dev/null | awk '/=> \//{print $3}'); do
			base="${dep##*/}"
			if [ ! -f "./AppDir/lib/$base" ] && [ -f "$dep" ]; then
				cp -Lv "$dep" "./AppDir/lib/"
				new_libs=1
			fi
		done
	done
	[ "$new_libs" = 0 ] && break
done

# Refresh lib.path for sharun runtime discovery
./AppDir/sharun -g

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the AppImage under a virtual X11 display
quick-sharun --test ./dist/*.AppImage
