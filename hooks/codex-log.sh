#!/usr/bin/env bash
# PostToolUse logger: records Edit/Write/MultiEdit and Codex calls to JSONL.
# Data source of truth for /codex-audit and statusline.

input=$(cat)
mkdir -p ~/.claude/logs
log=~/.claude/logs/codex-usage.jsonl

echo "$input" | python3 -c "
import sys, json, datetime
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
tool = data.get('tool_name', '')
session = data.get('session_id', '')
ts = datetime.datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

if tool in ('Edit', 'Write', 'MultiEdit'):
    file = data.get('tool_input', {}).get('file_path', '')
    print(json.dumps({'ts': ts, 'session': session, 'tool': tool, 'file': file}))
elif tool == 'mcp__codex-cli__codex':
    prompt = data.get('tool_input', {}).get('prompt', '')[:120]
    print(json.dumps({'ts': ts, 'session': session, 'tool': 'codex', 'prompt_head': prompt}))
" >> "$log" 2>/dev/null

exit 0
