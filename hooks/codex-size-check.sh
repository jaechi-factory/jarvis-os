#!/usr/bin/env bash
# PreToolUse: enforce size (50+ line Edit / 100+ line Write) and
# per-turn file-count (2+ unique files) limits. [Claude: override] bypasses.

input=$(cat)

tool_name=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_name',''))" 2>/dev/null)

if [[ "$tool_name" != "Edit" && "$tool_name" != "Write" && "$tool_name" != "MultiEdit" ]]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

session_id=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)

# Look for override in current turn's assistant text
has_override="no"
if [[ -n "$session_id" ]]; then
  transcript=""
  for dir in ~/.claude/projects/*/; do
    candidate="${dir}${session_id}.jsonl"
    if [[ -f "$candidate" ]]; then
      transcript="$candidate"
      break
    fi
  done
  if [[ -n "$transcript" ]]; then
    last_user_line=$(grep -n '"type":"user"' "$transcript" | tail -1 | cut -d: -f1)
    last_user_line=${last_user_line:-0}
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
    if echo "$current_turn_text" | grep -qiE '\[Claude:\s*(override|long|판단|글쓰기|ignore)'; then
      has_override="yes"
    fi
  fi
fi

# Extract tool_input fields
file_path=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('file_path',''))" 2>/dev/null)
old_lines=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('old_string',''))" 2>/dev/null | wc -l | tr -d ' ')
new_lines=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('new_string',''))" 2>/dev/null | wc -l | tr -d ' ')
content_lines=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tool_input',{}).get('content',''))" 2>/dev/null | wc -l | tr -d ' ')

mkdir -p ~/.claude/state
turn_files=~/.claude/state/turn-edit-files.txt
touch "$turn_files"

if [[ "$has_override" == "no" ]]; then
  # File-count check (only triggers when adding a NEW file path)
  if ! grep -Fx "$file_path" "$turn_files" >/dev/null 2>&1; then
    current_count=$(sort -u "$turn_files" | grep -v '^$' | wc -l | tr -d ' ')
    if [[ "$current_count" -ge 1 ]]; then
      cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"이번 턴에 이미 파일 ${current_count}개 수정됨. 다파일 작업은 mcp__codex-cli__codex 위임 원칙. 판단/글쓰기 필요 시 [Claude: override] 선언으로 해제."}}
EOF
      exit 0
    fi
  fi

  total=$((old_lines + new_lines))
  if [[ "$tool_name" == "Edit" && "$total" -gt 50 ]]; then
    cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"50줄 초과 Edit (${total}줄). 기계적 큰 변경은 mcp__codex-cli__codex 위임. 판단/글쓰기면 [Claude: override]로 해제."}}
EOF
    exit 0
  fi

  if [[ "$tool_name" == "Write" && "$content_lines" -gt 100 ]]; then
    cat <<EOF
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"100줄 초과 Write (${content_lines}줄). 큰 파일 생성은 mcp__codex-cli__codex 위임. 판단/글쓰기/PRD면 [Claude: override]로 해제."}}
EOF
    exit 0
  fi
fi

# Passed: record this file to the turn tracker
echo "$file_path" >> "$turn_files"

echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
exit 0
