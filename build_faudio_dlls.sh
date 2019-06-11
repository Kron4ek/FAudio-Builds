#!/bin/sh

## Requirements: mingw-w64-cmake, mingw-w64-gcc, mingw-w64-sdl2, mingw-w64-ffmpeg
##
## Usage: ./build_faudio_dlls.sh 19.06

TARGET_DIR="${HOME}"
FFMPEG_DIR="${HOME}"/ffmpeg-4.1.3-win64-dev

cd "${TARGET_DIR}" || exit 1

wget https://github.com/FNA-XNA/FAudio/archive/$1.tar.gz
tar xf $1.tar.gz

cd FAudio-$1

x86_64-w64-mingw32-cmake -H. -B_build_mingw64 -DCMAKE_INSTALL_PREFIX="${TARGET_DIR}/faudio_x64" -DBUILD_CPP=ON -DINSTALL_MINGW_DEPENDENCIES=ON -DFFMPEG=ON -DFFmpeg_INCLUDE_DIR="${FFMPEG_DIR}/include/"
cmake --build _build_mingw64 --target install -- -j

mkdir "${TARGET_DIR}/faudio-$1"
mv "${TARGET_DIR}/faudio_x64/bin" "${TARGET_DIR}/faudio-$1/x64"
rm "${TARGET_DIR}/faudio-$1/x64/wine_setup_native"

cd "${TARGET_DIR}/faudio-$1"
wget "https://raw.githubusercontent.com/Kron4ek/FAudio-Builds/master/wine_setup_faudio.sh"
chmod +x wine_setup_faudio.sh
cd "${TARGET_DIR}"

echo "Compressing..."
tar -cf faudio-$1.tar faudio-$1
xz faudio-$1.tar

rm $1.tar.gz
rm -r FAudio-$1
rm -r faudio-$1
rm -r faudio_x64

clear
echo "FAudio build complete!"
