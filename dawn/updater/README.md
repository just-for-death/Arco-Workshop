## Game update script

### Description

This script automates following steps:

1. Check for game updates
2. Download the game files
3. Revert any previously applied patches
4. Install or update the game files
5. Apply the newest patch

If you prefer a graphical updater, check out:

 * [Paimon Launcher](https://notabug.org/loentar/paimon-launcher)
 * [An Anime Game Launcher](https://gitlab.com/KRypt0n_/an-anime-game-launcher)


### Requirements

This script requires following applications:

 * `bash` (update and patch script)
 * `jq` (JSON parsing)
 * Either `aria2c`, `wget`, `curl` or `axel` (file download)
 * `xdelta3` (patch script)


### Usage instructions

The script must be executed from the wanted game installation directory
using either relative or absolute paths to execute `update_gi.sh`.

By default, the downloaded archives are deleted after installation.
To disable this behaviour, append the `nodelete` argument.

 * Example: `sh "/path/to/dawn/updater/update_gi.sh" install nodelete`

If errors occur after updating the game files, [re-run the patch scripts manually](../#applying-the-workaround).


#### New installation

Installs the newest game version to an **empty** directory.

Syntax:

	sh "/path/to/dawn/updater/update_gi.sh" install

Example:

	# Install game to a new directory in HOME (~)
	mkdir -p "$HOME/Genshin Impact Game"
	cd "$HOME/Genshin Impact Game/"
	
	sh "/path/to/dawn/updater/update_gi.sh" install


#### Update installation

Updates the game in the working directory to the newest version.

**Important:** If the official launcher was used for the installation,
ensure that the working directory contains `GenshinImpact.exe` but not `launcher.exe`.

Syntax:

	sh "/path/to/dawn/updater/update_gi.sh"

Example:

	# Update game located in HOME
	cd "$HOME/Genshin Impact Game/"
	sh "/path/to/dawn/updater/update_gi.sh"
