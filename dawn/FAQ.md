# Frequently Asked Questions

Q: Can I get banned if I use this patch?  
A: Yes because this is a client modification. However, since the first patch in
December 2020 no bans in relation to this patch were reported.

Q: Why is this project rather difficult to find?  
A: Imagine what the game developers could do if they figured out that this patch
circumvents their rootkit service in order to reach Linux compatibility.
To keep the patch working, it is highly recommended to not share this project in public,
despite its MIT license. It is for your own good.

Q: How quickly do patches get released?  
A: Usually, the first testing patch is proposed within a day after the official game update
which happens on Wednesday (UTC). To check for issues, the patch is tested until Saturday,
after which the script is updated for normal use.

Q: Where can I use this patch?  
A: On GNU/Linux distributions, but it *may* also work on other systems which run Wine.
Windows does not need this patch and is not supported for obvious reasons.

Q: Does it work on MacOS?  
A: No, the game falsely detects MacOS as a virtual machine. See Issue #12 for details.

Q: How can I analyse my gacha wishes?  
A: Obtain the URL from `output_log.txt`. Open the
in-game wish history (table view), then search for `webview_gacha` within the file.
Extract the long URL and use it for the analyser tool.

Q: How do I skip the download of unused voice-over packs?  
A: Either remove them in your game settings, or:

 1. Locate the file `audio_lang_*` (where `*` stands for the newest) inside your game data files
 2. Remove the unwanted pack lines (except maybe `English(US)`?)
 3. Save
 4. Navigate to `StreamingAssets/Audio/GeneratedSoundBanks/Windows/`
 5. Remove the pack directories that are no longer contained within `audio_lang_*`
 6. Proceed to download the other game data archives

Q: Where is `output_log.txt`?  
A: `WINEPREFIX/drive_c/USERNAME/AppData/LocalLow/miHoYo/Genshin Impact/` where WINEPREFIX
depends on the Wine setup/configuration.

Q: Where can I find crash information?  
A: A minidump file and error log file are saved to `WINEPREFIX/drive_c/USERNAME/Temp/mihoyocrash_*`.
Former can partially be analysed using `winedbg` or `windbg` depending on the progress of Wine.

Q: Where is `WINEPREFIX`?

 * System-wide Wine installation: `~/.wine`
 * Lutris: `~/Games`
 * Steam: in `steamapps`, usually `~/.steam/steam/steamapps/compatdata/ANYNUMBER`
