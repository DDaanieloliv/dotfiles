if command -v tmux >/dev/null 2>&1 && [[ -z "$TMUX" ]]; then
  tmux attach -t main || tmux new -s main
fi

