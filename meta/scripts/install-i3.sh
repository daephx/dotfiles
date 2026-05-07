#!/usr/bin/env bash

set -e

# Detect package manager
detect_pm() {
  if command -v apt &> /dev/null; then
    echo "apt"
  elif command -v pacman &> /dev/null; then
    echo "pacman"
  else
    echo "unknown"
  fi
}

# Install on Debian/Ubuntu
install_apt() {
  echo "Detected Debian/Ubuntu system. Installing i3 via apt..."
  curl https://baltocdn.com/i3-window-manager/signing.asc | sudo apt-key add -
  sudo apt install apt-transport-https --yes
  echo "deb https://baltocdn.com/i3-window-manager/i3/i3-autobuild/ all main" |
    sudo tee /etc/apt/sources.list.d/i3-autobuild.list
  sudo apt update
  sudo apt install i3 --yes
}

# Install on Arch Linux
install_pacman() {
  echo "Detected Arch Linux system. Installing i3 via pacman..."
  sudo pacman -S i3-gaps i3lock i3status --noconfirm
}

# Route to correct installer
pm=$(detect_pm)
case $pm in
  apt) install_apt ;;
  pacman) install_pacman ;;
  *)
    echo "Error: Unsupported package manager: $pm"
    echo "Currently supported: apt (Debian/Ubuntu), pacman (Arch Linux)"
    echo "Please install i3 manually using your distribution's package manager."
    exit 1
    ;;
esac
