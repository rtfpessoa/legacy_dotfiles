#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

CONFIG_DIR="${1-$SCRIPT_DIR}"

function toLowerCase {
  echo $1 | tr '[:upper:]' '[:lower:]'
}

function tryRemove {
  TO_REMOVE="$@"

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

echo "Cleaning dead symlinks in '$HOME'..."
simlinks="$(find -L $HOME -maxdepth 1 -type l)"
if [ -n "$simlinks" ]; then
  tryRemove "$(find -L $HOME -maxdepth 1 -type l)"
else
  echo "No dead symlinks found!"
fi

echo "Cleaning fish shell..."
tryRemove $HOME/.local/share/fish $HOME/.config/fish $HOME/.local/share/omf $HOME/.cache/omf $HOME/.config/omf

echo "Cleaning rbenv..."
tryRemove $HOME/.rbenv

echo "Cleaning nodenv..."
tryRemove $HOME/.nodenv
tryRemove $HOME/.config/yarn

echo "Cleaning pyenv..."
tryRemove $HOME/.pyenv

echo "Cleaning jabba..."
tryRemove $HOME/.jabba

echo "Cleaning i3..."
tryRemove $HOME/.config/i3 $HOME/.xsession $HOME/.Xresources $HOME/.config/polybar $HOME/.config/rofi $HOME/.config/compton

echo "Cleaning i3 system..."
sudo systemctl stop undervolt.timer
sudo systemctl disable undervolt.timer
sudo systemctl stop undervolt.service
sudo systemctl disable undervolt.service
tryRemove /usr/share/xsessions/i3*.desktop /etc/X11/xorg.conf.d/40-libinput.conf /etc/systemd/system/undervolt.service /etc/systemd/system/undervolt.timer

echo "Cleaning extra fonts..."
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  tryRemove $HOME/.fonts
elif [[ "$OSTYPE" == "darwin"* ]]; then
  tryRemove '$HOME/Library/Fonts/*'
fi

echo "Completed!"
