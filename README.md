## FAudio Builds

FAudio MinGW (dlls) builds for Wine. Compiled with FFmpeg (and therefore WMA) support.

### When are these MinGW builds useful?

They are useful when using native FAudio library is not possible or difficult: old Linux distros that doesn't have FAudio in their repositories or old Wine versions (4.2 and older) that doesn't support native FAudio at all. They are also useful when native FAudio library is compiled without support for WMA decoding.

I recommend to use native FAudio library whenever possible.

Note that new Wine versions (6.20 and newer) include a MinGW (PE) build of FAudio and don't use (and don't need) the native FAudio library. However, i don't know if WMA supported.

---

## Installation

[**Download**](https://github.com/Kron4ek/FAudio-Builds/releases) release, extract the archive and use the **wine_setup_faudio.sh** script to install FAudio, and don't forget to specify path to your Wine prefix. For example:

    WINEPREFIX="$HOME/some_prefix" ./wine_setup_faudio.sh
    
It's also possible (but not necessary) to specify path to a Wine binary:

    WINE=/opt/wine-staging/bin/wine WINEPREFIX="$HOME/some_prefix" ./wine_setup_faudio.sh
    
The script creates symlinks to FAudio dlls, so **do not remove** FAudio directory after installation.

You can also use winetricks for installation:

    WINEPREFIX="$HOME/some_prefix" winetricks faudio
    
---

## FAudio description

FAudio is an XAudio reimplementation, it fixes sound issues in many games.

https://github.com/FNA-XNA/FAudio
