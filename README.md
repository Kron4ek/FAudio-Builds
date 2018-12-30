# FAudio Builds
Latest FAudio builds (dlls) for Wine. Compiled with FFmpeg support.

To install, copy (or symlink) all dlls to "prefix_path/drive_c/windows/system32" directory and override them to "Native" in winecfg. Or just use "wine_setup_faudio.sh" script, for example:

    WINEPREFIX="$HOME/.just_prefix" ./wine_setup_faudio.sh

Source: https://github.com/FNA-XNA/FAudio
