#!/bin/bash
# session-start-plugin-check.sh
# 세션 시작 시 호출. 두 가지 작업:
#   1. 미처리 알림(notifications/plugin-update-*.md)이 있으면 자비스에게 inject (stdout 출력)
#   2. 마지막 점검이 7일 초과면 백그라운드로 weekly-plugin-update.sh 실행

STATE_DIR="$HOME/.claude/state"
NOTIFY_DIR="$HOME/.claude/notifications"
LAST_FILE="$STATE_DIR/last-plugin-update"
WEEK=$((7 * 24 * 60 * 60))

# 1. 미처리 알림 inject
LATEST_NOTIFY=$(ls -t "$NOTIFY_DIR"/plugin-update-*.md 2>/dev/null | head -1)
if [ -n "$LATEST_NOTIFY" ] && [ -f "$LATEST_NOTIFY" ]; then
  echo "━━━ 🔔 Plugin Update 알림 (이전 세션 결과) ━━━"
  cat "$LATEST_NOTIFY"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  # 처리됨으로 이동 (다음 세션에 중복 표시 방지)
  mkdir -p "$NOTIFY_DIR/processed"
  mv "$LATEST_NOTIFY" "$NOTIFY_DIR/processed/" 2>/dev/null || true
fi

# 2. 7일 초과 체크 → 백그라운드 갱신
if [ -f "$LAST_FILE" ]; then
  LAST=$(cat "$LAST_FILE" 2>/dev/null || echo 0)
  NOW=$(date +%s)
  DIFF=$((NOW - LAST))
  if [ "$DIFF" -gt "$WEEK" ]; then
    nohup bash "$HOME/.claude/hooks/weekly-plugin-update.sh" > /dev/null 2>&1 &
    echo "[plugin-check] 마지막 점검 $((DIFF / 86400))일 전 — 백그라운드 갱신 시작"
  fi
else
  date +%s > "$LAST_FILE"
fi

exit 0
