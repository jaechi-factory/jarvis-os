#!/usr/bin/env bash
# PreToolUse hook (matcher: Edit|Write|MultiEdit)
# Codex 위임 정책 3단계 분기:
#   strict   — 코드 파일 직접 수정 차단 (기본)
#   advisory — Codex 사용 권장 메시지 표시 + 통과
#   off      — Claude 직접 수정 허용 (메시지 없음)
#
# 정책 변경: echo "advisory" > ~/.claude/state/codex-policy
# 또는 setup.sh interactive prompt에서 선택

policy_file="$HOME/.claude/state/codex-policy"
policy="strict"  # 기본값
if [ -f "$policy_file" ]; then
    policy=$(tr -d '[:space:]' < "$policy_file")
fi

# 코드 파일 패턴 검사 (Edit/Write/MultiEdit input의 file_path 추출)
path=$(echo "$CLAUDE_TOOL_INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('file_path',''))" 2>/dev/null)

# 코드 파일 아니면 정책 무관하게 통과
if ! echo "$path" | grep -qE "\.(ts|tsx|js|jsx|css|scss)$"; then
    exit 0
fi

case "$policy" in
    strict)
        echo "⛔ [Codex 위임 강제 · strict] 코드 파일 직접 수정 차단: $path"
        echo "   → mcp__codex-cli__codex 사용. 예외: Codex 실패 복구 또는 사용자 명시 허가('직접 해')."
        echo "   → 정책 변경: echo 'advisory' > ~/.claude/state/codex-policy (또는 'off')"
        exit 1
        ;;
    advisory)
        echo "💡 [Codex 위임 권장 · advisory] $path"
        echo "   → 다파일·반복 수정이면 mcp__codex-cli__codex 권장. 직접 수정도 허용."
        exit 0
        ;;
    off)
        # 메시지 없이 통과
        exit 0
        ;;
    *)
        echo "⚠️ [Codex 정책 알 수 없음: '$policy'] strict로 fallback"
        echo "   → 유효한 값: strict / advisory / off"
        exit 1
        ;;
esac
