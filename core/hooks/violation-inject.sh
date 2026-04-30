#!/usr/bin/env bash
# UserPromptSubmit hook
# 1. 직전 턴 .last-violation 있으면 자비스에게 inject (자가 회복 알림)
# 2. 이번 턴 사용자 prompt 저장 (Stop의 violation-check.sh 검사용)
# 3. 이번 턴 jsonl 시작 라인 마커 (Agent 카운트 기준점)
#
# SSOT: hook 설계 — JARVIS-OS 위반 회복 메커니즘

set -uo pipefail
state_dir="$HOME/.claude/state"
mkdir -p "$state_dir"

input=$(cat)

# 1. 직전 턴 위반 알림 inject (자비스에게 보임)
violation_file="${state_dir}/last-violation.txt"
if [ -f "$violation_file" ] && [ -s "$violation_file" ]; then
    echo ""
    echo "━━━ 🛡️ JARVIS-OS 자가 회복 알림 ━━━"
    cat "$violation_file"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    rm -f "$violation_file"
fi

# 2. 사용자 prompt 저장
prompt=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('prompt','')[:1000])" 2>/dev/null || echo "")
echo "$prompt" > "${state_dir}/last-prompt.txt"

# 3. jsonl 현재 라인 수 마커
date_today=$(date +%Y-%m-%d)
log_file="$HOME/.claude/audit/${date_today}.jsonl"
if [ -f "$log_file" ]; then
    line_count=$(wc -l < "$log_file" | tr -d ' ')
else
    line_count=0
fi
echo "$line_count" > "${state_dir}/turn-start-line.txt"

exit 0
