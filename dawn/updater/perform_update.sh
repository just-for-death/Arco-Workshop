#!/usr/bin/env bash

# Utility script to unzip an archive to $PWD and process HDiffPatch updates
# md5 archive sanity checks must be done by the caller function/application
#
# Usage: ./perform_update.sh "/path/to/archive.zip"

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

do_cleanup() {
	# Old patch files
	find -type f -name "*.hdiff" | while read filename; do
		rm "$filename"
	done

	# Prevent deleting of the possibly necessary files in case of full update.
	rm -f "deletefiles.txt"
	rm -f "hdifffiles.txt"
}


# ======== Evaluated variables
THIS_FILE=$(basename "$0")
THIS_PATH=$(realpath "$(dirname "$0")")
HDIFF_APP="${THIS_PATH}/HDiffPatch/hpatchz"
ZIP_FILE="$1"


# ======== Sanity checks
[ ! -e "config.ini" ] && fatal \
	"Game information file not found."
[ ! -e "$ZIP_FILE" ] && fatal \
	"Archive '${ZIP_FILE}' not found."
chmod +x "$HDIFF_APP"


# ======== Preparation
do_cleanup


# ======== Unzipping
short_name=$(basename "${ZIP_FILE}")
echo "--- Installing ${short_name} ... "
unzip -o "${ZIP_FILE}"
echo ""


# ======== *.hdiff files
set +e # to capture "$?"
find -type f -name "*.hdiff" | while read diffname; do
	realname="${diffname::-6}" # trim ".hdiff"
	if [ -e "$realname" ]; then
		echo "--- Patching file ${realname}"
		output=$("$HDIFF_APP" -f "$realname" "$diffname" "${realname}.tmp_hdiff")
		if [ $? -eq 0 ]; then
			mv -f "${realname}.tmp_hdiff" "$realname"
		else
			echo "$output"
			rm -f "${realname}.tmp_hdiff" # just in case
		fi
	else
		# let the game re-download
		echo "--- [WARNING] HDiff source not found: ${realname}"
	fi
	rm "$diffname"
done
set -e


# ======== deletefiles.txt
if [ -f "deletefiles.txt" ]; then
	while read -r filename; do
		filename=$(echo "${filename}" | tr -d '\r\n')
		# Safety check. File must be within the game directory.
		[ ! -f "${filename}" ] && continue;

		filepath_abs=$(readlink -nf "${PWD}/${filename}")
		case "$filepath_abs" in
			("$PWD"/*)
				echo "--- Removing old file: ${filename}"
				rm -f "$filepath_abs"
				continue
				;;
		esac
		echo "--- [WARNING] Attempt to remove: ${filename}"
	done < "deletefiles.txt"
fi


# ======== Final cleanup
do_cleanup

exit 0
