#!/usr/bin/env bash
# Copies every agent in ./agents to ~/.claude/agents so Claude Code can use them in any project.
set -euo pipefail
shopt -s nullglob

src="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/agents"
dest="$HOME/.claude/agents"

mkdir -p "$dest"

count=0
for file in "$src"/*.md; do
  install -m 0644 "$file" "$dest/$(basename "$file")"
  echo "Installed $(basename "$file") -> $dest"
  count=$((count + 1))
done

if [ "$count" -eq 0 ]; then
  echo "No agents found in $src" >&2
  exit 1
fi

echo "Done. Start a new session, for example: claude --agent ticket-maker"
