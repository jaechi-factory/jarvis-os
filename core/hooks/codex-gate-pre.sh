#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash)
# 비가역 명령 감지 시 차단 + Codex 적대적 리뷰 + Founder 명시 승인 강제
#
# Bypass: 명령 prepend 방식 — JARVIS_BYPASS_GATE=1 git push origin main
#         (영구 환경변수 설정 X. 매 호출마다 명시적으로 우회)
#
# SSOT: ~/.claude/rules/common/codex-delegation.md "고위험 게이트 모드"

input=$(cat)
cmd=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('command',''))" 2>/dev/null)

# Bypass 체크 — 명령 자체에 JARVIS_BYPASS_GATE=1 prepend 됐을 때만 우회
if echo "$cmd" | grep -qE "^[[:space:]]*JARVIS_BYPASS_GATE=1[[:space:]]"; then
  exit 0
fi

# 비가역 명령 패턴 (정규식)
PATTERNS='git[[:space:]]+push|git[[:space:]]+merge[[:space:]]|git[[:space:]]+rebase[[:space:]]+--onto|git[[:space:]]+reset[[:space:]]+--hard|vercel[[:space:]]+(deploy[[:space:]]+)?--prod|npm[[:space:]]+publish|pnpm[[:space:]]+publish|yarn[[:space:]]+publish|prisma[[:space:]]+migrate[[:space:]]+deploy|supabase[[:space:]]+db[[:space:]]+push|supabase[[:space:]]+migration[[:space:]]+up'

if echo "$cmd" | grep -qE "$PATTERNS"; then
  echo "🛡️ [고위험 게이트] 비가역 명령 감지" >&2
  echo "" >&2
  echo "명령: $cmd" >&2
  echo "" >&2
  echo "차단 사유: ABSOLUTE 역할 모델 — 비가역 작업은 Founder 명시 승인 필수." >&2
  echo "" >&2
  echo "필요 조치 (자비스가 {{USER_NAME}}에게 보고):" >&2
  echo "  1. Codex 적대적 리뷰 호출 (mcp__codex-cli__codex)" >&2
  echo "     프롬프트: rules/common/codex-delegation.md '적대적 리뷰 트리거' 표준 템플릿" >&2
  echo "  2. 리뷰 결과를 {{USER_NAME}}에게 보고 + 명시 승인 대기" >&2
  echo "  3. 승인 후 우회 실행: JARVIS_BYPASS_GATE=1 <원본 명령>" >&2
  echo "" >&2
  echo "audit log: codex_adversarial_gate_blocked 태그로 기록됨" >&2

  # audit log에 차단 이벤트 기록
  audit_dir="$HOME/.claude/audit"
  mkdir -p "$audit_dir"
  date_today=$(date +%Y-%m-%d)
  log_file="${audit_dir}/${date_today}.jsonl"
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  safe_cmd=$(echo "$cmd" | sed 's/\\/\\\\/g; s/"/\\"/g' | head -c 200)
  echo "{\"ts\":\"$ts\",\"event\":\"codex_adversarial_gate_blocked\",\"cmd\":\"$safe_cmd\"}" >> "$log_file"

  exit 1
fi

exit 0
