# Tweaks

This file lists some configuration file tweaks, performance tweaks, visual tweaks, and the likes of making your game run better.

## Performance tweaks

Please keep in mind that the minimal specifications also apply for Linux. Do not expect a performance gain compared to Windows native.


#### DXVK

Check whether the latest DXVK version is installed in your `WINEPREFIX`:

* Use default `WINEDEBUG` (no `-all`!) and check the (terminal) output
* `output_log.txt` ([what?](FAQ.md)) should mention DXVK

Setup instructions: [TROUBLESHOOTING.md](TROUBLESHOOTING.md#graphics-bugsissues)


#### Esync

Esync will sometimes work faster than Fsync on some specific game/machine combinations ([see here](https://flightlessmango.com/benchmarks/Esync_vs_Fsync)).

Please note that the official Wine builds do not come with Esync support.
One of the following builds is required:

**Lutris:**

 * Select game -> Configure -> Runner options -> "Enable Esync"
 * See also: [Official tutorial](https://github.com/lutris/docs/blob/master/HowToEsync.md)

**Proton:**

 * Enabled by default when running from the Steam library

**wine-staging or custom build:**

 * Add `export WINEESYNC=1` to your script prior to launching the game

If you have access to the terminal output (or logs),
look out for `Esync` mentions to confirm that it's working.


#### GPU bottleneck improvements

 * Stutter and low FPS on GPUs with <= 2 GB VRAM
    * For monitoring: `nvidia-smi`/`nvtop` (nVIDIA), `radeontop` (AMD)
    * Use DXVK 1.9.4 or newer (memory management improvements)
    * In-game setting: Change "Render Resolution" to 0.8 or lower
        * This setting changes the texture resolution, resulting in less VRAM usage
    * Disable Anti-Aliasing (less blur)
    * Close `zfgamebrowser.exe` to free approx. 60 MB (after DXVK 1.9.4)
 * In-game setting: Disable "Volumetric Fog". Introduces more lag than what's worth it
 * In-game setting: Lower "Shadow Quality". May improve the frame rates
 * Create a file named `dxvk.conf` where `GenshinImpact.exe` resides. Example options for vsync-less (mailbox mode), tearing-free, low latency gameplay:

```
# Change to 3 for triple buffering (improves performance at the cost of latency)
dxgi.numBackBuffers = 2
dxgi.syncInterval = 0
dxgi.tearFree = True
# More performance
d3d11.constantBufferRangeCheck = False
d3d11.relaxedBarriers = True
d3d11.invariantPosition = False
d3d11.zeroWorkgroupMemory = False
```

Also the environment variable `DXVK_ASYNC=1` might help to reduce stutters. This
feature is not available by default and requires a [special DXVK patch](https://github.com/Sporif/dxvk-async).


#### FSR - FidelityFX Super Resolution

FSR is an image upscaler which can improve game performance.
See [AMD website](https://www.amd.com/en/technologies/radeon-software-fidelityfx-super-resolution) for details.

**Caveats:**

 * Requires a native window (no virtual desktop)
 * Resolution changes must be done in windowed mode or by command line arguments
    * Use `Alt+Enter` to switch between windowed and fullscreen

This feature only comes with certain Wine builds, including:

 * proton-ge-custom
 * wine-ge-custom & Lutris-ge (Non-LoL builds)
 * Steam Proton, after [PR #116 is merged](https://github.com/ValveSoftware/wine/pull/116)
 * Kron4ek's Wine-Builds (check release page, must mention FSR)

Required command line arguments:

 * Append `-window-mode exclusive` after `launcher.bat`
    * Example: `??? cmd /c launcher.bat -window-mode exclusive`

Relevant environment variables:

 * `WINE_FULLSCREEN_FSR=1` -> enables FSR
 * `WINE_FULLSCREEN_FSR_STRENGTH=3` -> values from 0 (sharp) to 5 (blurry)
 * Instructions:
    * Steam: adjust the `Target` box. Example: `FOO=1 BAR=1 cmd.exe`
    * Lutris: add rows to `Configuration` -> `System options` -> `Environment variables`


#### Loading times

This is an optimization for installations on a slow drive.
You may make Linux' file caching to RAM more aggressive in order reduce loading
times for repetitive actions.

1. Open `etc/sysctl.conf` with an editor like `nano` with sudo.
2. Add the line `vm.vfs_cache_pressure = 10`. Save and exit.
3. Run `sudo sysctl -p` to reload the kernel configuration.


## Visual tweaks

#### Benchmark

* Set the environment variable `DXVK_HUD` to `fps,frametimes`
* For a fancier display, try [MangoHud](https://github.com/flightlessmango/MangoHud) instead.


#### Post Processing using vkBasalt

[vkBasalt](https://github.com/DadSchoorse/vkBasalt) offers cool shaders and re-shade-like features.

1. Disable in-game antialiasing
2. Create a file named `vkBasalt.conf` in the directory where `GenshinImpact.exe` resides.
3. Relevant information and examples:
    * Detailed descriptions: [official `vkBasalt.conf`](https://github.com/DadSchoorse/vkBasalt/blob/master/config/vkBasalt.conf)
    * User-provided presets: [static/](static/)
