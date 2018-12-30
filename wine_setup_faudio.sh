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

if [ ! -f "$WINEPREFIX/system.reg" ]; then
	echo "$WINEPREFIX does not seem like a valid Wine prefix"

	exit 1
fi

if [ -d "$WINEPREFIX/drive_c/windows/syswow64" ]; then
	PREFIX_ARCH=64
else
	PREFIX_ARCH=32
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

echo -e "\n$WINEPREFIX is a $PREFIX_ARCH-bit prefix\n"

if [ $PREFIX_ARCH = 64 ]; then
	if ls "$FAUDIO64_PATH"/*.dll &>/dev/null; then
		echo -e "Installing 64-bit FAudio dlls\n"

		for x in "$FAUDIO64_PATH"/*.dll; do
			echo "Installing $x"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/system32"
		done
	else
		echo -e "\n64-bit FAudio dlls not found"
		echo -e "Please, check if FAUDIO64_PATH is correct\n"

		NOFAUDIO64=1
	fi

	if ls "$FAUDIO32_PATH"/*.dll &>/dev/null; then
		echo -e "\nInstalling 32-bit FAudio dlls\n"

		for x in "$FAUDIO32_PATH"/*.dll; do
			echo "Installing $x"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/syswow64"
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
			echo "Installing $x"

			ln -sf "$x" "$WINEPREFIX/drive_c/windows/system32"
		done
	else
		echo -e "\n32-bit FAudio dlls not found"
		echo -e "Please, check if FAUDIO32_PATH is correct\n"

		NOFAUDIO32=1
	fi
	
	NOFAUDIO64=1
fi

override_dll () {
	name=$1

	# update registry
	log=$(wine reg add 'HKEY_CURRENT_USER\Software\Wine\DllOverrides' /v $name /d native /f 2>>/dev/null)

	if [ $? -ne 0 ]; then
		echo "Failed to update registry for $name"
		exit 1
	fi

	echo "$name: done"
}

if [ -z $NOFAUDIO32 ] || [ -z $NOFAUDIO64 ]; then
	echo -e "\nOverriding dlls\n"

	override_dll xaudio2_0
	override_dll xaudio2_1
	override_dll xaudio2_2
	override_dll xaudio2_3
	override_dll xaudio2_4
	override_dll xaudio2_5
	override_dll xaudio2_6
	override_dll xaudio2_7
	override_dll xaudio2_8
	override_dll xaudio2_9

	override_dll x3daudio1_3
	override_dll x3daudio1_4
	override_dll x3daudio1_5
	override_dll x3daudio1_6
	override_dll x3daudio1_7

	override_dll xactengine3_0
	override_dll xactengine3_1
	override_dll xactengine3_2
	override_dll xactengine3_3
	override_dll xactengine3_4
	override_dll xactengine3_5
	override_dll xactengine3_6
	override_dll xactengine3_7

	override_dll xapofx1_1
	override_dll xapofx1_2
	override_dll xapofx1_3
	override_dll xapofx1_4
	override_dll xapofx1_5

	echo

	if [ -z $NOFAUDIO32 ]; then echo "32-bit FAudio installed"; fi

	if [ $PREFIX_ARCH = 64 ]; then
		if [ -z $NOFAUDIO64 ]; then echo "64-bit FAudio installed"; fi
	fi

	echo "Installation completed!"
else
	echo "FAudio not found. Nothing to install."
	echo "Check if FAUDIO32_PATH and FAUDIO64_PATH are correct."
fi
