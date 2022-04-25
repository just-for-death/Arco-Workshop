# Troubleshooting

To add new solutions, please open a pull request, issue or contact me directly.

Sorted by appearance from installation (top) to gameplay (bottom).


### List of problematic Wine versions

 * Wine 7.5+: Broken batch file execution; stuck with `find.exe`. See below or Issue #291
 * Wine 7.3 - 7.5: May require a manual wineprefix update. See below or Issue #273
 * Wine 6.21 (Lutris?): Possible freeze before login screen - Issue #224
 * Wine 6.15 (vanilla): Crash when entering or leaving multiplayer
 * Wine 6.14: Suspected audio playback problems - Issue #218
 * Wine 6.10: Crash in HID when using a controller - Issue #133
 * Wine 6.0 (staging): Possible stutter issues on AMD graphics - Issue #40
 * Wine 5.19: Occasional crash while preparing media (login screen)
 * Wine 5.3 and older: Missing StartThreadpoolIo implementation


#### Launcher: Game download issues

Download works but launcher freezes/crashes midway:

 * Use a recent Wine version (Wine 6.13+ confirmed working)
 * Use a custom [Update & Patch application](updater/) as an alternative to the official launcher
 * See Issue #28 for details

The memory footprint of `winedevice.exe` grows continuously:

 * Wine bug: see [bug tracker](https://bugs.winehq.org/show_bug.cgi?id=52322)
 * Option 1: Close and re-open the launcher to continue
 * Option 2: Use a custom launcher/[Update & Patch application](updater/)
 * See Issue #118 for details


#### Launcher: Failed to unzip game files

1. Check for launcher updates
2. Edit `/path/to/Genshin Impact Game/config.ini`
3. Adjust the line `game_version=X.X.X` to the currently installed version
4. Re-run the launcher to install the update

Alternatively: re-download the entire game. See Issue #28 for direct links.


#### Game does not start at all

1. Check & update the game version in the official launcher
2. Apply the patches as described in `README.md`

A `find.exe` command window is shown but never exits:

 * Happens since Wine 7.5 when running `cmd /c launcher.bat` without a terminal.
   Wine spawns a `find.exe` process in a separate window which breaks the batch script.
 * Workaround: Use a virtual desktop or run `wine cmd ...` from a terminal
 * For details, see Issue #291


#### 'find' or 'start' cannot be found

Alternatively: `notepad.exe` opens on launch, displaying an error message.

Possible causes:

 * Old Lutris Wine package (prior to "lutris-6.4")
 * Incomplete or corrupted WINEPREFIX setup

Solutions:

 * Try another package, such as Proton or stock/vanilla Wine.
 * Use a new WINEPREFIX. Move the game installation.
 * Attempt to repair an existing one using `wineboot -u`
     * This step requires the environment variable `WINEPREFIX` to be specified.

For more details, see Issue #78.


#### Game crashes on launch

1. Ensure the patch is applied
2. Retry without kernel sync (ESYNC, FSYNC, ...)
3. Lutris: disable "Lutris Runtime" ([for reference](https://notabug.org/Krock/dawn/issues/78#issuecomment-24727))


#### Game crash related to the wineprefix

Wine output log example:

 * `wine: Call from XXXXXX to unimplemented function combase.dll.RoSetErrorReportingFlags, aborting`

This applies to Wine 7.3 or newer but not Proton. Either:

 * Update your WINEPREFIX using `wineboot -u`
     * Command execution is possible from both, shell and `cmd.exe`.
 * Create a new WINEPREFIX, reinstall DXVK (if possible) and retest
     * The game installation should be located outside any prefix to avoid accidental deletion.


#### Game no longer works on Windows

 * This is intentional to avoid abuse of this project
 * If you are Dual-Booting, write a batch script to swap the game files as needed


#### StartThreadpoolIo not found in KERNEL32.dll

 * Use Wine 5.3 or newer. This function has been added recently.
 * For more details, see [Issue#12](https://notabug.org/Krock/dawn/issues/12#issuecomment-22060).


#### Login shows a white rectangle

After activating the "Login" button, a white rectangle appears.
If the Captcha does not appear after 20 seconds, check for solutions in
the following Troubleshooting entries:

 * "Error 4206"
 * "In-game browser looks weird or crashes the game"


#### Error 4206 or "Connection timed out"

Possible error sources:

 * Faulty DNS server
 * Domain(s) blocked by ISP
 * Custom domain block lists (albeit unlikely)

In rare cases, this issue may be weekday-dependent for unknown reasons.

Solutions: tab ["PC client issues"](https://docs.google.com/spreadsheets/d/1I3aaXaNbHm-igAsFwvlCEHr5xyQKO4Wot8TuywsOhxw/htmlview#)

 * Manually specify Domain Name Server (DNS) addresses
 * Use a VPN


#### Freeze when loading game data

Unknown cause. Please submit ideas to Issue #90

 * Ensure that an audio output device is enabled
 * Run the game using `-nolog`: `??? cmd /c launcher.bat -nolog`
 * Try another graphics driver or setup a clean, new WINEPREFIX


#### Crash after 20 seconds due to sound output

First seen in version 2.1.0 using PulseAudio.

Check whether the terminal output (`WINEDEBUG` value is irrelevant) contains following line:

 * `INFO: OpenAudioDevice failed: Unsupported number of audio channels`

.. and change the sound output settings to Analog Stereo.


#### An error code appears

Common errors and possible causes. `x` stands for any number:

 * -900x
     * Out of free storage
     * Check the read and write permissions of the entire game
       directory, and the `Persistent` sub-directory in particular
 * -9908
     * The downloaded data is corrupt. Try a wired connection.


#### White screen freeze when entering the door
... plus error log "*err:virtual:virtual_setup_exception stack overflow*".

Starting from version 1.2.0, this error reappears a few days after each release. It is caused by server-sent bytecode.

Workaround:

	bash "/path/to/dawn/GAMEVER/patch_anti_logincrash.sh"


#### Crash when initially loading the world (7 symbols)
... + `error.log` message containing `XAudio2_7.dll caused an Access Violation (0xc0000005)`

Rare occurrence related to an audio failure. Observed in Wine 5.22 and newer.


1. Restart the game
2. Check for music and button sound effects

This crash might also occur when WineD3D is used rather than DXVK.

 * Check the [setup instructions](INSTALLATION.md) again


#### Crash after a few seconds in-game
... + `error.log` message containing `HID.DLL caused an Access Violation (0xc0000005)`

Obsolete. Observed in Wine 6.10 only.


#### In-game browser looks weird or crashes the game

 * `winetricks corefonts`
 * Ubuntu/Debian: install `ttf-mscorefonts-installer`
 * Re-install dxvk (if present)
 * Try running the game in a virtual desktop

Other font installations might work as well as long Fontconfig can use them as fallback.


#### ZFGameBrowser crash

 * Ignore and restore the game window
 * For input issues: try the virtual desktop (see below)

For more details, see Issue #29.


#### Graphics bugs/issues

Check whether your GPU supports Vulkan: [unofficial list](https://vulkan.gpuinfo.org/), [Intel](https://www.intel.com/content/www/us/en/support/articles/000005524/graphics.html), [nVIDIA](https://developer.nvidia.com/vulkan-driver), [AMD](https://www.amd.com/en/technologies/vulkan#paragraph-218601)

Setup instructions:

 * Custom script:
     * Download [winetricks](https://github.com/Winetricks/winetricks/)
     * `export WINEPREFIX=/absolute/path/` (if needed)
     * `sh winetricks`
     * Install the DLL package `dxvk` (newest, or 1.7.3 for Proton 5.13)
 * Lutris: Configure -> Runner options -> "Enable DXVK" and specify the version
 * Proton: See [setup instructions](INSTALLATION.md#steam)
 * PlayOnLinux: (outdated DXVK?)
     * Configure game -> Install components -> [Latest DXVK version]

To confirm whether DXVK is working, check the section "Game is on an LSD trip".


#### Game is on an LSD trip

(This means that surfaces have very distinct colors)

This issue is often caused by an outdated or missing DXVK installation.

How to check (general approach):

 * Launch with the environment variable `DXVK_HUD=version,devinfo,fps`
     * A HUD must appear in the top left corner
 * Check whether version 1.7.3 or newer is shown
 * Alternatively, following lines in the terminal output indicate lack of DXVK:
     * `fixme:d3d11:wined3dformat_from_dxgi_format`
     * `fixme:d3d:wined3d_check_device_multisample_type`
     * `fixme:d3d_shader:print_glsl_info_log`
 * For installation hints check the section "Graphics bugs/issues" above.

Intel iGPU specific issues:

 * Update Mesa to a recent version, newer is better
 * See [Release Notes](https://docs.mesa3d.org/relnotes.html) for "ANV" mentions and fixes
 * See Issue #152 for the original report.

In case software rendering, i.e. `llvmpipe` is used by accident. This is most common on AMD GPUs:

1. Check whether software rendering is used
     * Either: search for `lavapipe` in the terminal output upon launch
     * Or: search for `Device name` + `llvmpipe` in [`output_log.txt`](FAQ.md) after launch
2. Install proper Vulkan packages:
     * Check tutorials, such as [LinuxConfig](https://linuxconfig.org/install-and-test-vulkan-on-linux) or [Arch Wiki](https://wiki.archlinux.org/title/Vulkan#Installation)
3. Repeat step 1 to confirm your changes


#### Mouse/keyboard input issues

Easiest solution: Use a virtual desktop.

 * Custom script: `wine explorer /desktop=anyname,1920x1080 cmd /c launcher.bat`
     * Adjust the resolution numbers to your needs
 * Steam + Proton: See [setup instructions](INSTALLATION.md#steam)
 * Lutris: Go to "Runner options" -> Enable "Windowed (virtual desktop)"

Without a virtual desktop: (experimental)

 * winecfg -> Check "Automatically capture the mouse in full-screen windows"
 * `WINEPREFIX="/path/to/prefix" winetricks usetakefocus=n`
     * Lutris already does this by default.

Inputs ignored after focus loss: (Unity framework specifc)

 * Use `Alt+Enter` to toggle to windowed mode
 * Drag the window, focus the desktop, focus the game window (again)
 * When the title bar indicates focus, switch back to fullscreen mode

See also: search engine query `unity wine focus`


#### Too high mouse sensitivity

This workaround is meant for overall high mouse sensitivity.
In case this issue occurs only after switching between workspaces, check the sections below.

Disable `MouseWarpOverride` using Winetricks:

	WINEPREFIX="/path/to/prefix" winetricks mwo=disable


#### Alt + Mouse click not working

Cinnamon users:

 * Workaround: Disable the window move & resize feature
     * See [Linux Mint forums](https://forums.linuxmint.com/viewtopic.php?t=264172)

Xfce4 users:

 * Same solution as in the `causes the view to "spin"` issue below


#### Switching between workspaces causes the view to "spin"

Change the in-game resolution setting:

1. Focus the (virtual) desktop
2. Focus the game window again. The title bar must be marked as active (blue).
3. Change the resolution back to fullscreen

Alternative: use Proton.


#### Wrong window resolution

If the in-game settings are not accessible, do one of the following:

 * Append following arguments after `launcher.bat`:
     * `-screen-width XXX -screen-height YYY -screen-fullscreen 1`
 * Alternative: `-show-screen-selector` to change the settings on startup
 * Alternative: change the virtual desktop's size (if present)
 * Alternative: use regedit to change the keys in `HKCU\Software\...`

See also: [Unity CLI args](https://docs.unity3d.com/Manual/CommandLineArguments.html)


#### Weak graphics, slow game

For performance improving tweaks see [TWEAKS.md](TWEAKS.md).

This may also be caused by software rendering. Check `Game is on an LSD trip` above.

For hybrid graphics (dGPU + iGPU) in laptops:

1. Use the environment variable `DXVK_HUD=version,devinfo,fps`
2. If the dGPU (such as nVIDIA or AMD) is shown, go to the section "Game is on an LSD trip".
3. If the iGPU (Intel or AMD integrated) is shown:
     * For nVIDIA: Launch Wine with [`prime-run`](https://wiki.archlinux.org/title/PRIME#PRIME_render_offload)
     * ^ If `pvkrun` does not work, uninstall [`bumblebee`](https://wiki.archlinux.org/title/Bumblebee) prior to installing `prime-run`
     * For AMD: Use the environment variable `PRIME_RUN=1`
4. Repeat the check in step 1

**Note:** If Lutris is used, environment variables can be specified in the `System options` tab


#### Locale-specific keyboard layout not working

Upon input, question mark signs (`?`) appear rather than the typed characters.

Gnome: Move the locale-specific layout to second place

  * [Example configuration](https://notabug.org/attachments/3994e09e-e7a1-4c34-83a1-87c5e421375b)

Change the environment variable `LANG` to your locale

 * See [Lutris forum](https://forums.lutris.net/t/solved-need-help-launching-a-game-with-custom-locale/6404) for a solution
 * Custom script: `LANG=your_LOCALE.UTF8 wine ....`
 * Lutris: Configure -> "System options" -> Add `LANG`, `your_LOCALE.UTF8`
   to the environment variables
 * Steam: In the "Target" input box, add `LANG=your_LOCALE.UTF8` in front

If the problem persists: create or update a WINEPREFIX using your locale
 * `WINEPREFIX=/path/to/wineprefix/ LANG=your_LOCALE.UTF8 /path/to/wineboot -u` (untested)


#### Voiced cutscenes lack audio playback

 * Ensure that `faudio` is installed (Ubuntu: `libfaudio0`)
     * See also: [official Wine setup instructions](https://wiki.winehq.org/Download)
 * Try another, newer Wine version


#### "Feedback" and "Special Event" buttons crash Wine

These menu buttons are broken since their introduction.
Following workarounds exist:

"Feedback" button:

1. For Gacha analytics: check [FAQ.md](FAQ.md) for alternatives
2. Check your in-game mail. It should contain a working URL.
     * Important: `zfgamebrowser.exe` must *still* be running (default)
3. If there is no mail, wait for the reminder (arrives a few days).

"Special Event" button:

1. Check the in-game browser for event links.
     * This is unreliable and might crash Wine in some cases
2. Obtain the link from official channels or community. (e.g. Twitter)


#### Crash when joining co-op

See "White screen freeze when entering the door".


### Information sources

 * [PlayOnLinux](https://www.playonlinux.com/en/app-4228.html)
 * [NotABug issue tracker](https://notabug.org/Krock/dawn/issues)


### How to report issues

Please upload long log files to an external service such as:

 * https://pastecord.com/
 * https://paste.debian.net/
 * https://pastebin.com/
 * https://dpaste.com/

Following information can help to speed up the troubleshooting process:

1. What are you using: custom script, Lutris, Steam, other?
2. Did you follow the installation instructions?
3. Provide the WINEDEBUG terminal output
     * Custom script: `wine ????? 2>debug.txt` (redirect stderr to a new file)
     * Lutris: [Obtaining log output for games](https://github.com/lutris/docs/blob/master/ProvidingLogs%26SystemInfo.md#obtaining-log-output-for-games)
     * Steam: start Steam from the terminal: `PROTON_LOG=1 steam`
          * Log files are saved to `$HOME/steam-*.log`
4. Driver information
     * `lspci -v | grep "VGA" -A 15`
     * `inxi -Ga`
