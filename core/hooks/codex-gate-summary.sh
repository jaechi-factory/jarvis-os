#!/usr/bin/env bash
# Stop hook — codex-gate-post.sh가 남긴 tmp 파일 읽어 자비스에 다음 응답 강제 액션 알림
#
# SSOT: ~/.claude/rules/common/codex-delegation.md "고위험 게이트 모드"

trigger_file="/private/tmp/jarvis-codex-gate-trigger.txt"

if [ -f "$trigger_file" ] && [ -s "$trigger_file" ]; then
  echo ""
  echo "━━━ 🛡️ 고위험 게이트 발동 ━━━"
  echo "다음 변경에서 고위험 패턴 감지:"
  sort -u "$trigger_file" | sed 's/^/  • /'
  echo ""
  echo "[자비스 다음 응답에서 강제 액션]"
  echo "  1. Codex 적대적 리뷰 호출 (mcp__codex-cli__codex)"
  echo "     프롬프트: rules/common/codex-delegation.md '적대적 리뷰 트리거' 표준 템플릿"
  echo "  2. 새 리스크 발견 시 → CEO 보고 + 명시 승인 대기"
  echo "  3. 통과 시 → 5블록 [상위 검토 & 반영]에 'Codex 적대적 검증 PASS' 명시"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━"

  # 한 번 출력 후 삭제 (다음 답변에 다시 안 뜨게)
  rm -f "$trigger_file"
fi

exit 0
