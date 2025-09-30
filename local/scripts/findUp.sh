#!/bin/bash
set -e # exit script on failure

# Place this script in /opt/scripts, make its permissions 755, and use in the following fashion:
# to find gradlew: /opt/scripts/findUp.sh . -iname gradlew

path="$1"
shift 1
firstMatch=""
while [[ $path != / && "$firstMatch" == "" ]];
do
    firstMatch="$(find "$path" -maxdepth 1 -mindepth 1 "$@")"
    # Note: if you want to ignore symlinks, use "$(realpath -s "$path"/..)"
    path="$(readlink -f "$path"/..)"
done

if [[ "$firstMatch" == "" ]]; then
    echo "# Error! Did NOT find what you were looking for in any parent directory [$@]" 1>&2
    exit 64
else
    echo "$firstMatch"
fi

# ORIGINAL DOC
# https://unix.stackexchange.com/questions/6463/find-searching-in-parent-directories-instead-of-subdirectories
# find_up.sh some_dir -iname "foo*bar" -execdir pwd \;
