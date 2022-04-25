# Game installation instructions

Minimal requirements:

 * Any installation of `wine` >= 5.3 (sooner or later)

Highly recommended:

 * Vulkan-capable graphics card (["How to check?"](TROUBLESHOOTING.md#graphics-bugsissues))


### Table of contents

* [Lutris](#lutris)
* [Steam](#steam)
* [Custom](#custom)
* [Controller Configuration](#controller-configuration)


#### Lutris

1. Download the Windows installer from the official site
2. Add the installer binary to your library
3. Set up a wineprefix for the game
    * This is where the game will be installed. 40+ GiB of free space is highly recommended.
    * Grab a recent Wine runner. See [TROUBLESHOOTING](TROUBLESHOOTING.md) for problematic versions
4. Install the components the game needs to run flawlessly
    * Open Winetricks via the context menu
    * Install the font `corefonts`.
    * Enable DXVK in `Configuration` -> `Runner options` (1.7.3 or newer is recommended)
5. Launch the downloaded installer .exe
    * Use the `Run EXE inside wine prefix` menu action for this.
    * The C++ Redistributable Package is optional. You may cancel it.
    * Download and install the game files.
    * **Once it is done, do not press launch.** Exit the launcher.
6. Apply the patch script: ["how?"](README.md)
7. Play the game
    * In `Configuration` -> `Game options` -> `Executable` path, browse and select
      `launcher.bat` which you can find in the same directory as `GenshinImpact.exe`
    * Launch the game

**Important note:**

After setup you might have multiple Wine versions and multiple WINEPREFIX directories
on your system. Hence running the `wine` command from your terminal will use another
environment than Lutris does.

To open a command prompt which uses the correct environment, do either:

 * Games -> Wine options (see bottom status bar or left side) -> `Wine console`
 * Change the `Executable` path to `cmd.exe`


#### Steam

1. Download the official launcher
2. "Add non-Steam game..." -> Show all files -> Select the launcher executable -> Done
3. Setup proton (if not done using global settings)
    * Navigate: Gear icon -> "Settings" -> "Compatibility"
    * Check "Force compatibility layer ..."
    * Select Proton 5.13 or newer
4. Install the launcher and start it
    * The C++ Redistributable Package is optional. You may cancel it.
    * Download and install the game files.
5. Apply the patch script: ["how?"](README.md)
6. Update the target. Gear icon -> "Settings":
    * Target: `explorer.exe`
    * Execution directory: `/path/to/your/gi/installation/`
    * Start options: `/desktop=anyname,1920x1080 cmd /c launcher.bat`
    * Adjust the screen resolution above, if necessary.
7. Play.


#### Custom

Script-based approach to use any Wine version on any WINEPREFIX.
If you do not understand what each step is supposed to do, use Lutris instead.

For the final game launch script after the prefix setup, use steps 1, 2 and 6.

	# 1. Specify the path to wine(64)
	#    This can be either system-wide or a custom installation
	WINE="wine64"
	#WINE="$HOME/.local/share/Steam/steamapps/common/Proton 5.13/dist/bin/wine64"
	
	# 2. Specify a WINEPREFIX
	export WINEPREFIX="/absolute/path/to/.prefix/"
	
	# 3. Create or update WINEPREFIX
	"$WINE" wineboot -u
	
	# 4. Install DXVK (v1.9.4, for Wine 5.14+)
	#    Use the newest Winetricks script from GitHub
	export WINE
	sh winetricks dxvk194
	
	# 5. Install the game (if not already done)
	"$WINE" "/path/to/installer.exe"
	
	# 6. Game launch
	cd "/path/to/Genshin Impact Game"
	export WINEESYNC=1  # requires staging or Proton, see TWEAKS.md
	"$WINE" explorer /desktop=anyname,1920x1080 cmd /c launcher.bat
	
	# 7. Game update
	#    See `updater/README.md` or attempt to use the official launcher:
	"$WINE" "/path/to/official/launcher.exe"


#### Controller Configuration

*This section should not be documented in this repository.
If you know of a better public place for documentation, please open an issue
so that this information is available to more people.*

Only follow these instructions if the newest Wine version does not already support your controller.


##### Dualsense

*Source: lahvuun, Issue #216*

1. Open `regedit` in your WINEPREFIX
2. Navigate to `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\winebus`
3. Create a new DWORD, value `0`, named `Enable SDL`
4. If there is yet no success: check the udev rule section below

Caveats: No force feedback or haptics (vibrations)


##### Other

*Source: Alex72, Issue #228*

General idea: specify the environment variable `SDL_GAMECONTROLLERCONFIG=?????`.

Helpful resources to determine the value (`?????`):

 * For permission-related issues: check the udev rule section below
 * General mapping information: [SDL_GameControllerDB](https://github.com/gabomdq/SDL_GameControllerDB)
 * [SDL2 controller test tool](https://github.com/libsdl-org/SDL/blob/main/test/controllermap.c)
    * Required packages: build tools and SDL2
       * Debian/Ubuntu: `libsdl2-dev`
    * Compile with `gcc -o controllermap controllermap.c $(sdl2-config --libs --cflags)`
    * If compiling fails, either:
       * Install a newer SDL2 library
       * or download an older `controllermap.c` file which matches your installed version
 * [SDL2 Gamepad Mapper](https://gitlab.com/ryochan7/sdl2-gamepad-mapper)
 * [AntiMicroX](https://github.com/AntiMicroX/antimicrox)


##### udev rule configuration

Some specific controllers might lack read permission.

 * If [game-devices-udev](https://gitlab.com/fabiscafe/game-devices-udev) lists your controller, install it.
    * Run `udevadm control --reload-rules` or reboot to apply the changes
 * Arch Wiki instructions for other controllers: [Gamepad](https://wiki.archlinux.org/title/Gamepad)

Maybe helpful: `wine control.exe` shows a simple controller/gamepad testing application.
