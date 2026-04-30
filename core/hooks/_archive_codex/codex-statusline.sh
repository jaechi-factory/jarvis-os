#!/usr/bin/env bash
# Statusline: show session-level Edit vs Codex counts with warning when skewed.

input=$(cat)
export SESSION_ID=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)
export LOG_FILE="$HOME/.claude/logs/codex-usage.jsonl"

python3 <<'PY'
import json, os
session = os.environ.get('SESSION_ID', '')
log = os.environ.get('LOG_FILE', '')
edit = codex = 0
try:
    with open(log) as f:
        for line in f:
            try:
                d = json.loads(line)
            except Exception:
                continue
            if session and d.get('session') != session:
                continue
            t = d.get('tool', '')
            if t in ('Edit', 'Write', 'MultiEdit'):
                edit += 1
            elif t == 'codex':
                codex += 1
except FileNotFoundError:
    pass

if edit == 0 and codex == 0:
    print('📎 Codex: idle')
else:
    warn = '⚠️  ' if edit > 2 and codex == 0 else ''
    print(f'📎 {warn}Edit:{edit} / Codex:{codex}')
PY
