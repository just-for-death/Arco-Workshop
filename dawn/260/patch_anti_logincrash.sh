#!/usr/bin/env bash

#echo "[NOTE] This patch is in general not required since version 2.3.0."
#echo "       If your game freezes at the 7th element in the loading screen,"
#echo "       request a patch file in the issue tracker."
#echo "       edit this script file to comment/remove the line below."
#exit 0

echo "[NOTE] This patch is not required as of 2022-03-30. However, it might become"
echo "       necessary afterwards (Friday?). If that's the case, comment the line below."
exit 0

# MacOS and *BSD do not have md5sum: use md5 instead
if [[ $(uname) == "Darwin" || $(uname) == *"BSD" ]]; then
	md5sum() {
		md5 -q $@
	}
fi

DIR=$(dirname "${BASH_SOURCE[0]}")
DATADIR=$(find -type d -name "*_Data")
FILE="$DATADIR/Plugins/xlua.dll"
sum=($(md5sum $FILE))
reltype=""

# original hashes
if [ "${sum}" == "79689dad712cc0063d9a23b15491b828" ]; then
	reltype="os"
	echo "--- Applying for: International (OS) version"
fi
if [ "${sum}" == "e76a81c2417e2490da61380ddb4705b4" ]; then
	reltype="cn"
	echo "--- Applying for: Chinese (CN) version"
fi
if [ -z "$reltype" ]; then
	# The patch might corrupt invalid/outdated files if this check is skippd.
	echo "[ERROR] Wrong file version or the patch is already applied"
	echo " -> md5sum: ${sum}" && exit 1
fi


# =========== DO NOT REMOVE START ===========
if [[ -e "$DIR/$FILE" ]]; then
	# There is a good reason for this check. Do not pollute the game directory.
	echo "[ERROR] Invalid patch download directory. Please move all"
	echo "        patch files outside the game directory prior executing."
	echo " -> See README.md for proper installation instructions" && exit 1
fi
# ===========  DO NOT REMOVE END  ===========


if ! command -v xdelta3 &>/dev/null; then
	echo "[ERROR] xdelta3 application is required"
	exit 1
fi

echo "[INFO]    Patch to fix a login and runtime crash"
echo ""

# ===========================================================
echo "[WARNING] Hereby you are violating the game's Terms of Service!"
echo "          Do you accept the risk and possible consequences?"
read -p "Accept? [y/n] " choice

if [[ ! "$choice" == [JjSsYy]* ]]; then
	exit 1
fi

echo
echo "--- Applying xLua patch"
xdelta_fail() {
	mv -vf "$FILE.bak" "$FILE"
	exit 1
}

mv -f "$FILE" "$FILE.bak"
# Perform patch or restore .bak on failure
xdelta3 -d -s "$FILE.bak" "$DIR/patch_files/xlua_patch_${reltype}.vcdiff" "$FILE" || xdelta_fail

# Done!
echo "==> Patch applied! Enjoy the game."

exit 0
