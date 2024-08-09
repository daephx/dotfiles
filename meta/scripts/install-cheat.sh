#!/usr/bin/env bash

# User install
mkdir -p "$XDG_LOCAL_BIN"
curl https://cht.sh/:cht.sh >"$XDG_LOCAL_BIN/cht.sh"
chmod +x "$XDG_LOCAL_BIN/cht.sh"

# Global Install
# curl -s https://cht.sh/:cht.sh | sudo tee /usr/local/bin/cht.sh &&
# 	sudo chmod +x /usr/local/bin/cht.sh
