#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

CONFIG_DIR="${1-$SCRIPT_DIR}"

function toLowerCase {
	echo $1 | tr '[:upper:]' '[:lower:]'
}

function tryRemove {
	TO_REMOVE=$1

	read -p "Going to remove '$TO_REMOVE', are you sure? [Y/n]" response
	if [[ $(toLowerCase $response) =~ ^(yes|y) ]]; then
		rm -rf $TO_REMOVE
		echo "'$TO_REMOVE' removed!"
	else
		echo "'$TO_REMOVE' skipped!"
	fi
}

echo "Removing Unix configs..."

cd $HOME

echo "Removing configs dir..."
tryRemove "$CONFIG_DIR"

echo "Cleaning bins dir..."
tryRemove "$HOME/.bins"

echo "Cleaning dead symlinks in '$HOME'..."
simlinks="$(find -L $HOME -maxdepth 1 -type l)"
if [ -n "$simlinks" ]; then
	tryRemove "$(find -L $HOME -maxdepth 1 -type l)"
else
	echo "No dead symlinks found!"
fi

echo "Completed!"
