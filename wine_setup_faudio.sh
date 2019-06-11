#!/bin/bash

export DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

if [ -z "$WINEPREFIX" ]; then
	WINEPREFIX="$HOME/.wine"

	echo "WINEPREFIX is not specified, using ~/.wine"
else
	echo "WINEPREFIX is set to $WINEPREFIX"
fi

if [ -z "$WINE" ]; then
	WINE=wine

	echo "WINE is not specified, using default wine binary"
else
	echo "WINE is set to $WINE"
fi

if [ ! -f "$WINEPREFIX/system.reg" ]; then
	echo -e "\n$WINEPREFIX does not seem like a valid Wine prefix"
	exit 1
fi

if [ ! -d "$WINEPREFIX/drive_c/windows/syswow64" ]; then
	echo "Seems like your WINEPREFIX is not a 64-bit prefix!"
	exit 1
else
	WINEARCH=win64
fi

if [ -z "$FAUDIO64_PATH" ]; then
	echo "FAUDIO64_PATH is not specified, using "${DIR}"/x64"

	FAUDIO64_PATH="$DIR/x64"
else
	echo "FAUDIO64_PATH is set to $FAUDIO64_PATH"
fi

if ! "$WINE" --version &>/dev/null; then
	echo
	echo "Seems like Wine is not installed in your system."
	echo "Please, install Wine and launch script again."
	echo
	echo "If Wine is installed in different location,"
	echo "set WINE variable to path to wine binary."

	exit 1
fi

override_dll () {
	"$WINE" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v $1 /d native /f &>/dev/null

	if [ $? -ne 0 ]; then
		echo "Failed to override $1"
		exit 1
	fi
}

if ls "$FAUDIO64_PATH"/*.dll &>/dev/null; then
	echo -e "\nInstalling 64-bit FAudio dlls\n"

	for x in "$FAUDIO64_PATH"/*.dll; do
		echo "Installing $(basename "$x")"

		ln -sf "$x" "$WINEPREFIX/drive_c/windows/system32"
		override_dll $(basename "$x" .dll)
	done
else
	echo -e "\n64-bit FAudio dlls not found!"
	echo -e "Please, check if FAUDIO64_PATH is correct\n"

	exit 1
fi

echo -e "\nInstallation complete!"
