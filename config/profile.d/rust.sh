# Rust settings
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
if [ -f "$CARGO_HOME/env" ]; then
  source "$CARGO_HOME/env"
fi
