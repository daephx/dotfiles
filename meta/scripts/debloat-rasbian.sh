#!/bin/bash

# Remove unused packages
sudo apt-get --yes remove --purge \
bluej \
chromium-browser* \
claws-mail \
debian-reference-* \
dillo \
epiphany-browser* \
geany* \
gpicview \
greenfoot \
libreoffice* \
minecraft-pi \
nodered \
openjdk-7-jre \
openjdk-8-jre \
oracle-java7-jdk \
oracle-java8-jdk \
piclone \
python-* \
python3-automationhat \
python3-blinkt \
python3-buttonshim \
python3-cap1xxx \
python3-drumhat \
python3-envirophat \
python3-explorerhat \
python3-fourletterphat \
python3-microdotphat \
python3-mote \
python3-motephat \
python3-pantilthat \
python3-phatbeat \
python3-pianohat \
python3-picraft \
python3-piglow \
python3-rainbowhat \
python3-scrollphat \
python3-scrollphathd \
python3-thonny \
python3-touchphat \
python3-unicornhathd \
realvnc-vnc-server \
realvnc-vnc-viewer \
scratch* \
sense-emu-tools \
sense-hat \
smartsim \
snapd \
sonic-pi \
supercollider* \
wolfram-engine

# Remove unused directory
sudo rm -R /usr/share/python_games

# Auto-remove dependencies
sudo apt-get autoremove -y

# Clean
sudo apt-get autoclean -y

# Update
sudo apt-get update
