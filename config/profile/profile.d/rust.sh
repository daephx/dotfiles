# Rust: Configuration for Rust toolchain
# shellcheck disable=SC1091
# shellcheck shell=sh

# Define custom directories for Rust tools.
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

# Load Cargo environment if the file exists.
if [ -f "$CARGO_HOME/env" ]; then
  . "$CARGO_HOME/env"
fi
