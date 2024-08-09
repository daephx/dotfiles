#!/usr/bin/env sh

# Path variables
ICONS="$HOME/.local/share/icons"
THEMES="$HOME/.local/share/themes"

# Dependencies
# - Ensure gnome shell extensions are available
if ! command -v gnome-shell-extension-tool &> /dev/null; then
  sudo apt install gnome-shell-extensions
fi

# Download themes

cd "/tmp"

echo "Downloading from github: '/tmp/candy-icons'"
curl -L https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip -o candy-icons-master.zip

echo "Downloading from github: '/tmp/Sweet-Dark'"
curl -LO https://github.com/EliverLara/Sweet/releases/latest/download/Sweet-Dark-v40.zip

echo "Installing from archives."
unzip -o candy-icons-master.zip -d $ICONS
unzip -o Sweet-Dark-v40.zip -d $THEMES

echo "Removing downloaded archives."
rm -f ./candy-icons-master.zip ./Sweet-Dark-v40.zip
exit

# Apply themes to gnome

echo "Applying Gnome themes."
gsettings set org.gnome.desktop.interface icon-theme 'candy-icons-master'
gsettings set org.gnome.desktop.interface gtk-theme "Sweet-Dark-v40"
gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark-v40"
gsettings set org.gnome.shell.extensions.user-theme name 'Sweet-Dark-v40'

echo "Gnome themes 'Sweet-Dark' & 'Candy-Icons' has been installed"
