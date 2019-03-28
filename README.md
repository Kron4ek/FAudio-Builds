## FAudio Builds

FAudio MinGW (dlls) builds for Wine. Compiled with FFmpeg (and therefore WMA) support.

---

## Installation

Use **wine_setup_faudio.sh** script to install FAudio. And don't forget to specify path to your Wine prefix. For example:

    WINEPREFIX="$HOME/some_prefix" ./wine_setup_faudio.sh
    
Script creates symlinks to FAudio dlls, so **don't remove** FAudio directory after installation.

---

## FAudio description

FAudio is an XAudio reimplementation, it fixes sound issues in many games.

https://github.com/FNA-XNA/FAudio
