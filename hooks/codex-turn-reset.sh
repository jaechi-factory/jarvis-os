#!/usr/bin/env bash
# UserPromptSubmit: clear per-turn file tracking so each user prompt starts fresh.
mkdir -p ~/.claude/state
: > ~/.claude/state/turn-edit-files.txt
exit 0
