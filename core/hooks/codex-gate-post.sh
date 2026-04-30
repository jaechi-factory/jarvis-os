#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write|MultiEdit|mcp__codex-cli__codex)
# 고위험 경로/패턴 변경 감지 시 tmp 파일에 기록 → Stop hook이 자비스에 알림
#
# SSOT: ~/.claude/rules/common/codex-delegation.md "고위험 게이트 모드"

input=$(cat)
tool=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)

trigger_file="/private/tmp/jarvis-codex-gate-trigger.txt"
audit_dir="$HOME/.claude/audit"
mkdir -p "$audit_dir"
date_today=$(date +%Y-%m-%d)
log_file="${audit_dir}/${date_today}.jsonl"

# 고위험 경로/파일명 정규식
HIGH_RISK_REGEX='auth/|payment/|checkout/|migration/|migrations/|secrets/|\.env(\.|$)|credential|token|jwt|bcrypt|password'

detected=""

case "$tool" in
  Edit|Write|MultiEdit)
    path=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)
    if echo "$path" | grep -qiE "$HIGH_RISK_REGEX"; then
      detected="$path"
    fi
    ;;
  mcp__codex-cli__codex)
    # Codex 호출 후 git diff 검사 (Codex의 workingDirectory 또는 현재 디렉토리)
    cwd=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('workingDirectory','') or '')" 2>/dev/null)
    if [ -z "$cwd" ]; then
      cwd=$(pwd)
    fi
    if command -v git >/dev/null 2>&1 && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
      changed=$(git -C "$cwd" diff --name-only HEAD 2>/dev/null | grep -iE "$HIGH_RISK_REGEX" | head -5)
      if [ -n "$changed" ]; then
        detected=$(echo "$changed" | tr '\n' ',' | sed 's/,$//')
      fi
    fi
    ;;
esac

if [ -n "$detected" ]; then
  # tmp 파일 누적 기록 (한 답변 내 여러 발동 가능)
  echo "$tool: $detected" >> "$trigger_file"

  # audit log
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  safe_detected=$(echo "$detected" | sed 's/\\/\\\\/g; s/"/\\"/g' | head -c 200)
  echo "{\"ts\":\"$ts\",\"event\":\"codex_adversarial_gate_triggered\",\"tool\":\"$tool\",\"path\":\"$safe_detected\"}" >> "$log_file"
fi

exit 0
