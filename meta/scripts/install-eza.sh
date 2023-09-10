#!/usr/bin/env bash

set -e

wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo tee /etc/apt/trusted.gpg.d/gierens.asc
echo "deb http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
