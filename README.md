# FAudio Builds
FAudio MinGW (dlls) builds for Wine. Compiled with FFmpeg (and therefore WMA) support.

---

## Installation

Use **wine_setup_faudio.sh** script to install FAudio. And don't forget to specify path to your Wine prefix. Example:

    WINEPREFIX="$HOME/some_prefix" ./wine_setup_faudio.sh
    
Script create symlinks to FAudio dlls, so **don't remove** FAudio directory after installation.

---

## FAudio description

[FAudio](https://github.com/FNA-XNA/FAudio) is an XAudio reimplementation, it fix sound issues in many games. For example, it fix sound in TES V Skyrim: Special Edition and Fallout 4.

https://github.com/FNA-XNA/FAudio
