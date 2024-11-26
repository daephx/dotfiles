#!/usr/bin/env sh
# Rust: Configure toolchain directories and load Cargo settings.
# shellcheck disable=SC1091

# Define custom directories for Rust tools.
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Load Cargo environment if the configuration file exists.
if [ -f "$CARGO_HOME/env" ]; then
  . "$CARGO_HOME/env"
fi
