# FAudio Builds
Latest FAudio builds (dlls) for Wine. Compiled with FFmpeg (and therefore WMA) support.

To install, copy (or create symlinks) all dlls to **"PREFIX_PATH/drive_c/windows/system32"** directory and override them to "Native" in winecfg. Or just use **"wine_setup_faudio.sh"** script, for example:

    WINEPREFIX="$HOME/some_prefix" ./wine_setup_faudio.sh
    
Script create symlinks to FAudio dlls, so **don't remove** FAudio directory after installation.

Source: https://github.com/FNA-XNA/FAudio
