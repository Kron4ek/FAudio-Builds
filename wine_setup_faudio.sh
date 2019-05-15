#!/bin/bash

export SCRIPT="$(readlink -f "${BASH_SOURCE[0]}")"
export DIR="$(dirname "$SCRIPT")"

echo

if [ -z "$WINEPREFIX" ]; then
	WINEPREFIX="$HOME/.wine"

	echo "WINEPREFIX is not specified, using $WINEPREFIX"
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

if [ -d "$WINEPREFIX/drive_c/windows/syswow64" ]; then
	PREFIX_ARCH=64
	WINEARCH=win64
else
	PREFIX_ARCH=32
	WINEARCH=win32
fi

if [ -z "$FAUDIO32_PATH" ]; then
	echo "FAUDIO32_PATH is not specified, using "${DIR}"/x32"

	FAUDIO32_PATH="$DIR/x32"
else
	echo "FAUDIO32_PATH is set to $FAUDIO32_PATH"
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

	exit
fi

echo -e "\n$WINEPREFIX is a $PREFIX_ARCH-bit prefix\n"

override_dll () {
	"$WINE" reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v $1 /d native /f &>/dev/null

	if [ $? -ne 0 ]; then
		echo "Failed to override $1"
		exit 1
	fi
}

if [ $PREFIX_ARCH = 64 ]; then
	if ls "$FAUDIO64_PATH"/*.dll &>/dev/null; then
		echo -e "Installing 64-bit FAudio dlls\n"

		for x in "$FAUDIO64_PATH"/*.dll; do
			echo "Installing $(basename "$x")"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/system32"
			override_dll $(basename "$x" .dll)
		done
	else
		echo -e "\n64-bit FAudio dlls not found"
		echo -e "Please, check if FAUDIO64_PATH is correct\n"

		NOFAUDIO64=1
	fi

	if ls "$FAUDIO32_PATH"/*.dll &>/dev/null; then
		echo -e "\nInstalling 32-bit FAudio dlls\n"

		for x in "$FAUDIO32_PATH"/*.dll; do
			echo "Installing $(basename "$x")"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/syswow64"
			override_dll $(basename "$x" .dll)
		done
	else
		echo -e "\n32-bit FAudio dlls not found"
		echo -e "Please, check if FAUDIO32_PATH is correct\n"

		NOFAUDIO32=1
	fi
else
	if ls "$FAUDIO32_PATH"/*.dll &>/dev/null; then
		echo -e "Installing 32-bit FAudio dlls\n"

		for x in "$FAUDIO32_PATH"/*.dll; do
			echo "Installing $(basename "$x")"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/system32"
			override_dll $(basename "$x" .dll)
		done
	else
		echo -e "\n32-bit FAudio dlls not found"
		echo -e "Please, check if FAUDIO32_PATH is correct\n"

		NOFAUDIO32=1
	fi

	NOFAUDIO64=1
fi

if [ -z $NOFAUDIO32 ] || [ -z $NOFAUDIO64 ]; then
	echo

	if [ -z $NOFAUDIO32 ]; then echo "32-bit FAudio installed"; fi

	if [ $PREFIX_ARCH = 64 ]; then
		if [ -z $NOFAUDIO64 ]; then echo "64-bit FAudio installed"; fi
	fi

	echo -e "\nInstallation completed!"
else
	echo "FAudio not found. Nothing to install."
	echo "Check if FAUDIO32_PATH and FAUDIO64_PATH are correct."
fi
