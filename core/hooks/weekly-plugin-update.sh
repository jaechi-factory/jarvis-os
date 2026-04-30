#!/bin/bash
# weekly-plugin-update.sh
# 주 1회 백그라운드 자동 갱신. SessionStart hook이 7일 초과 감지 시 호출.
# 결과는 ~/.claude/notifications/에 저장 → 다음 세션에서 자비스에게 inject.

set -e

STATE_DIR="$HOME/.claude/state"
LOG_DIR="$HOME/.claude/logs"
NOTIFY_DIR="$HOME/.claude/notifications"
mkdir -p "$STATE_DIR" "$LOG_DIR" "$NOTIFY_DIR"

DATE_TAG=$(date +%Y%m%d-%H%M%S)
LOG="$LOG_DIR/plugin-update-$DATE_TAG.log"

echo "=== Weekly Plugin Update: $(date) ===" > "$LOG"

UPDATED_COUNT=0
UPDATED_LIST=""

# 설치된 플러그인 목록 추출 (plugin@marketplace 형식)
PLUGINS=$(claude plugin list 2>/dev/null | grep "❯" | sed 's/.*❯ //' | sed 's/ *$//')

while IFS= read -r plugin; do
  [ -z "$plugin" ] && continue
  echo "[$plugin]" >> "$LOG"
  RESULT=$(claude plugin update "$plugin" 2>&1 || true)
  echo "$RESULT" >> "$LOG"
  echo "" >> "$LOG"

  if echo "$RESULT" | grep -q "updated from"; then
    UPDATED_COUNT=$((UPDATED_COUNT + 1))
    LINE=$(echo "$RESULT" | grep "updated from" | head -1)
    UPDATED_LIST="${UPDATED_LIST}- ${LINE}"$'\n'
  fi
done <<< "$PLUGINS"

# 마지막 점검 시점 갱신
date +%s > "$STATE_DIR/last-plugin-update"

# 알림 파일 작성 (변경된 플러그인이 1개 이상일 때만)
if [ "$UPDATED_COUNT" -gt 0 ]; then
  NOTIFY="$NOTIFY_DIR/plugin-update-$(date +%Y%m%d).md"
  cat > "$NOTIFY" <<EOF
# 🔔 Plugin Update Notification — $(date '+%Y-%m-%d %H:%M')

**$UPDATED_COUNT 개 플러그인 자동 업데이트됨.** 재시작 후 적용됩니다.

## 변경 내역
${UPDATED_LIST}

## 자비스 후속 조치 권장
1. 새 스킬·트리거가 추가됐는지 확인 (특히 claude-mem, compound-engineering 같은 활발한 플러그인)
2. 디렉터별 매핑(현재 97개) 재조정 필요 여부 검토
3. \`/check-rules\` 로 정합성 검증

**전체 로그**: \`$LOG\`
EOF
  echo "Done. Updated: $UPDATED_COUNT, Notification: $NOTIFY"
else
  echo "Done. No updates. All $((UPDATED_COUNT + $(echo "$PLUGINS" | wc -l))) plugins already at latest version."
fi
