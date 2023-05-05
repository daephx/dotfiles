# Autostart tmux if available
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi
