#!/usr/bin/env bash

# Checker: shellcheck --shell=sh --exclude=SC2006,SC3043 update_gi.sh | less

# Exit on error.
set -e

fatal() {
	echo
	for arg in "$@"; do
		echo "  *  $arg" >&2
	done
	echo

	exit 1
}


# ======== Global constants
UPDATE_URL_OS='https://sdk-os-static.mihoyo.com/hk4e_global/mdk/launcher/api/resource?key=gcStgarh&launcher_id=10'
UPDATE_URL_CN='https://sdk-static.mihoyo.com/hk4e_cn/mdk/launcher/api/resource?key=eYd89JmJ&launcher_id=18'
#UPDATE_URL_OS='http://127.0.0.1:8000/dummy/resource.json?arg1=foo&arg2=bar'
CONFIG_FILE='config.ini'
ANCHOR_FILE='UnityPlayer.dll'


# ======== Voice pack constants
LANG_PACKS_PATH_OS='GenshinImpact_Data/StreamingAssets/Audio/GeneratedSoundBanks/Windows'
LANG_PACKS_PATH_CN='YuanShen_Data/StreamingAssets/Audio/GeneratedSoundBanks/Windows'
LANG_MAP_ENGLISHUS='en-us'
LANG_MAP_JAPANESE='ja-jp'
LANG_MAP_KOREAN='ko-kr'
LANG_MAP_CHINESE='zh-cn'


# ======== Evaluated variables
THIS_FILE=`basename "$0"`
THIS_PATH=`realpath "$(dirname "$0")"`
REPO_PATH=`dirname "$THIS_PATH"` # parent
reltype=""        # OS or CN, filled later.
remove_archives=1 #  0 or 1, filled later.


# ======== Dependency checks
# Check is all required tools installed.
for appname in jq bash unzip xdelta3; do
	exepath=`command -v "$appname" | tee`
	[ ! -e "$exepath" ] && fatal \
		"Required tool not found!" \
		"Please install: ${appname}."
done


# ======== Download tool setup
DOWNLOAD_PATH="../_update_gi_download"
#DOWNLOAD_PATH="../download with   spaces"
DL_APP_ARGS_axel='-n 15'
DL_APP_ARGS_aria2c='--no-conf -c'
DL_APP_ARGS_fetch='--force-restart --no-mtime --retry --keep-output --restart'
DL_APP_ARGS_wget='-c'
DL_APP_ARGS_curl='--disable -C -'

# Find first available download tool.
for appname in axel aria2c fetch wget curl; do
	# Pipe to "tee" overwrites the exit status
	exepath=`command -v "$appname" | tee`
	if [ -e "$exepath" ]; then
		DL_APP_BIN="$exepath"
		eval DL_APP_ARGS="\$DL_APP_ARGS_${appname}"
		break
	fi
done
[ ! -e "$DL_APP_BIN" ] && fatal \
	"No downloader application found." \
	"Please install one of: ${DL_APPS_LIST}."
echo "--- Using download application: ${DL_APP_BIN} ${DL_APP_ARGS}"


# ======== Functions

# MacOS and *BSD do not have md5sum: use md5 instead
exepath=$(command -v md5 | tee)
if [ -e "$exepath" ]; then
	md5check() {
		# 1 = Checksum, 2 = File
		md5 -q -c "$1" "$2" >/dev/null 2>&1
	}
else
	md5check() {
		# 1 = Checksum, 2 = File
		local input=`echo "$1" | tr 'A-Z' 'a-z'`
		local filesum=`md5sum "$2" | cut -d ' ' -f1`
		if [ "$input" != "$filesum" ]; then
			echo "Mismatch!"
			exit 1
		fi
	}
fi

download_file() {
	local url="$1"
	local dst_path="$2"
	local md5="$3"
	local filename_args="${dst_path}/${url##*/}"
	local filename="${filename_args%%\?*}"
	local filename_completed="${filename}.completed"

	echo

	mkdir -p "$dst_path"
	if [ -f "$filename_completed" ]; then
		echo "--> Skipping: Already downloaded."
	else
		(cd "$dst_path" && "$DL_APP_BIN" $DL_APP_ARGS "$url")
		if [ -n "$md5" ]; then
			echo -n '--- Verifying MD5 checksum ... '
			md5check "$md5" "$filename"
			echo 'OK'
			touch "$filename_completed"
		fi
	fi
}

# Approximate size of the installed archive
download_json_size() {
	local size=`echo "$1" | jq -r -M ".size"`

	size="$((($size + 1048576) / 1024 / 1024 / 2))"
	echo "~${size} MiB"
}

download_json_section() {
	local json_text="$1"
	local url=`echo "$json_text" | jq -r -M ".path"`
	local md5=`echo "$json_text" | jq -r -M ".md5"`

	download_file "$url" "$DOWNLOAD_PATH" "$md5"
}

get_ini_value() {
	local filename="${1}"
	local variable="${2}"
	grep "${variable}=" "${filename}" | tr -d '\r\n' | sed -e 's|.*=||g'
}


# ======== Path sanity checks
# There is a good reason for this check. Do not pollute the game directory.
[ -e "${THIS_PATH}/${ANCHOR_FILE}" ] && fatal \
	"Please move this script outside the game directory prior executing." \
	" -> See README.md for proper installation instructions"
# In case people accidentally want to install the game into the launcher directory.
[ `find ./*.dll 2>/dev/null | wc -l` -gt 2 ] && fatal \
	"This script is likely run in the wrong directory." \
	"Found more than two DLL files. (expected: 0...2)" \
	"Please run this script in a proper/clean game directory."


# ======== Command line processing

cli_help=0
cli_install=0

for arg in "$@"; do
case "$arg" in
	-h|--help|help)
		cli_help=1
		;;
	install)
		cli_install=1
		;;
	nodelete)
		remove_archives=0
		echo "--- Archives will not be deleted after download"
		;;
	*)
		fatal "Unknown option: ${arg}"
esac
done

if [ "$cli_help" -eq 1 ]; then
	cat << HELP
	${THIS_FILE} [-h|help] [install] [nodelete]

	This script will modify the current working directory.
	See README.md for details and examples.

	"install"  : new game installation from scratch
	"nodelete" : whether to keep the downloaded archives

HELP

	exit 0
fi

# New game installation option
if [ "$cli_install" -eq 1 ]; then
	if [ `find ./* 2>/dev/null | wc -l` -gt 0 ]; then
		fatal "'${PWD}' contains files and/or subdirectories." \
			"Please use an empty directory for a new installation." \
			"To update or resume an installation, rerun this script without the 'install' argument."
	fi

	echo ""
	echo "Which game build would you like to install?"
	echo "    0 -> Genshin Impact [America/Europe/Asia/TW,HK,MO]"
	echo "    1 -> YuanShen       [Mainland China]"
	read -p "Install [0/1] (0): " choice

	if [[ -z "$choice" || "$choice" == "0" ]]; then
		reltype="OS"
		echo -ne '[General]\r\nchannel=1\r\ncps=mihoyo\r\ngame_version=0.0.0\r\nsdk_version=\r\nsub_channel=0\r\n' >"$CONFIG_FILE"
	elif [ "$choice" = "1" ]; then
		reltype="CN"
		echo -ne '[General]\r\nchannel=1\r\ncps=mihoyo\r\ngame_version=0.0.0\r\nsdk_version=\r\nsub_channel=1\r\n' >"$CONFIG_FILE"
	else
		exit 1
	fi
else
	# Check for existing installation
	if [ -e "GenshinImpact.exe" ]; then
		reltype="OS"
	elif [ -e "YuanShen.exe" ]; then
		reltype="CN"
	fi
fi


# ======== Configuration file parsing
game_not_found_message=(
	"Make sure 'Genshin Impact Game' is the current working directory."
	"If you would like to install the game append the 'install' option:"
	"bash '${THIS_PATH}/${THIS_FILE}' install"
)

[ -z "$reltype" ] && fatal \
	"Cannot determine the installed game type." \
	"${game_not_found_message[@]}"

eval LANG_PACKS_PATH="\$LANG_PACKS_PATH_${reltype}"
eval UPDATE_URL="\$UPDATE_URL_${reltype}"
# $reltype is no longer used

[ ! -e "$CONFIG_FILE" ] && fatal \
	"Game information file ${CONFIG_FILE} not found." \
	"${game_not_found_message[@]}"

installed_ver=`get_ini_value "${CONFIG_FILE}" 'game_version'`
[ -z "$installed_ver" ] && fatal \
	"Cannot read game_version from ${CONFIG_FILE}. File corrupt?"

echo "--- Installed version: ${installed_ver}"


# ======== Update information download + meta checks

# WARNING: File cannot be downloaded to NTFS/FAT* partitions due to special characters
tmp_path=`mktemp -d`
trap "rm -rf '$tmp_path'" EXIT
download_file "$UPDATE_URL" "$tmp_path"

RESOURCE_FILE=`find "$tmp_path" -name 'resource*' | tee`

[ ! -f "${RESOURCE_FILE}" ] && fatal \
	"Failed to download version info. Check your internet connection."

upstream_ver=`jq -r -M '.data .game .latest .version' "$RESOURCE_FILE" | tee`
echo "--- Latest version: ${upstream_ver}"

if [ "$upstream_ver" = "$installed_ver" ]; then
	echo
	echo "==> Client is up to date."
	exit 0
fi

# Check whether this version can be patched
patcher_dir="$REPO_PATH"/`echo "$upstream_ver" | tr -d .`
[ ! -d "$patcher_dir" ] && fatal \
	"No suitable patch script found. Please check the bug tracker for details about the progress."


# ======== Select update type

# Check is diff update possible.
archive_json=`jq -r -M ".data .game .diffs[] | select(.version==\"${installed_ver}\")" "$RESOURCE_FILE"`
if [ -z "$archive_json" ]; then
	# Fallback to full download.
	archive_json=`jq -r -M '.data .game .latest' "$RESOURCE_FILE"`
	dl_type="new installation"
else
	dl_type="incremental update"
fi
size=`download_json_size "$archive_json"`
echo "Download type: ${dl_type} (${size})"

# Confirm install/update.
while :; do
	read -r -p "Start/continue update? [Y/n]: " input
	#input="y"
	case "$input" in
		Y|y|'')
			echo
			break
			;;
		n|N)
			exit 0
			;;
	esac
done

# Download main game archive
download_json_section "$archive_json"


# ======== Locate and install voiceover packs

if [ -d "$LANG_PACKS_PATH" ]; then
	# Get voiceover directory name in capitals. Does proper space handling.
	lang_dir_names=$(find "$LANG_PACKS_PATH" -mindepth 1 -type d | xargs -L1 -r basename | tr -d '()' | tr 'a-z' 'A-Z')
fi

# Download langs packs.

echo "$lang_dir_names" | while read dir_name; do
	[ -z "$dir_name" ] && continue
	eval lang_code="\$LANG_MAP_${dir_name}"

	lang_archive_json=`echo ${archive_json} | jq -r -M ".voice_packs[] | select(.language==\"${lang_code}\")"`
	if [ "$lang_archive_json" = 'null' -o "$lang_archive_json" = '' ]; then
		echo "--- Cannot find update for language: ${dir_name}"
		continue
	fi
	size=`download_json_size "$lang_archive_json"`
	echo "--- Voiceover pack: ${lang_code} (${size})"
	download_json_section "$lang_archive_json"
done


# ======== Revert patch & apply update

# Run 'patch_revert.sh' on update existing installation.
if [ -e "$ANCHOR_FILE" ]; then
	echo
	echo "============== Reverting previous Wine patch ==============="
	bash "${patcher_dir}/patch_revert.sh"
	echo "============================================================"
	echo
fi


# Unpack the game files and remove old ones according to deletefiles.txt
echo "--- Updating game files...."

find "${DOWNLOAD_PATH}" -name "*.zip" | while read archive_name; do
	bash "${THIS_PATH}/perform_update.sh" "$archive_name"
done
if [ "$remove_archives" -eq 1 ]; then
	# Remove downloads when all updates succeeded
	# otherwise keep the archives to fix with "perform_update.sh" manually
	find "${DOWNLOAD_PATH}" -name "*.zip" | while read archive_name; do
		rm -f "${archive_name}" "${archive_name}.completed"
	done
fi


# ======== Config update and game patching

# Update version in config file.
sed -i "s/game_version=${installed_ver}/game_version=${upstream_ver}/" "$CONFIG_FILE"

if [ "$remove_archives" -eq 1 ]; then
	# The directory should be empty now. Remove.
	rm -r "$DOWNLOAD_PATH"
fi
echo
echo "==> Update to version ${upstream_ver} completed"


# Run wine compatibility patch script.
echo
echo "================= Applying new Wine patch =================="
bash "${patcher_dir}/patch.sh"
echo "============================================================"
echo "==> Update script completed successfully"


exit 0
