#!/usr/bin/env bash
# PreToolUse: block Edit/Write/MultiEdit if current turn has no [Claude]/[Codex] declaration.
# Scans assistant text output since the last user message in the session transcript.

input=$(cat)

session_id=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)

if [[ -z "$session_id" ]]; then
  # Fail open when session unknown — don't break unrelated flows.
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

# Find transcript file
transcript=""
for dir in ~/.claude/projects/*/; do
  candidate="${dir}${session_id}.jsonl"
  if [[ -f "$candidate" ]]; then
    transcript="$candidate"
    break
  fi
done

if [[ -z "$transcript" ]]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

# Find line number of last user message
last_user_line=$(grep -n '"type":"user"' "$transcript" | tail -1 | cut -d: -f1)
last_user_line=${last_user_line:-0}

# Extract assistant text content since then
current_turn_text=$(tail -n +$((last_user_line + 1)) "$transcript" | python3 -c "
import sys, json
out = []
for line in sys.stdin:
    try:
        obj = json.loads(line)
    except Exception:
        continue
    if obj.get('type') != 'assistant':
        continue
    for block in obj.get('message', {}).get('content', []):
        if block.get('type') == 'text':
            out.append(block.get('text', ''))
print('\n'.join(out))
" 2>/dev/null)

# Accept [Claude], [Claude: ...], [Codex], [Codex: ...]
if echo "$current_turn_text" | grep -qE '\[(Claude|Codex)(\]|:)'; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"[Claude] 또는 [Codex] 선언 누락. Edit/Write/MultiEdit 호출 전 이 턴 안에 반드시 한 줄 선언 필요. 예: [Claude] 경로 — 사유 / [Codex] 경로 — 사유. 큰 판단 작업은 [Claude: override]로 사이즈 제한도 해제 가능."}}
EOF
exit 0
