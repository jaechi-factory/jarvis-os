#!/usr/bin/env bash
# JARVIS-OS v1.2 — 자동 설치 스크립트
# https://github.com/jaechi-factory/jarvis-os
#
# 사용법 (받는 사람):
#   1. Claude Code 설치 (claude.ai/code)
#   2. 터미널에서 한 줄:
#        bash <(curl -sL https://raw.githubusercontent.com/jaechi-factory/jarvis-os/main/setup.sh)
#   또는 Claude Code에 첫 메시지로:
#        "https://github.com/jaechi-factory/jarvis-os 설치해줘"
#
# 동작:
#   - 기존 ~/.claude 자동 백업
#   - core/ → ~/.claude/ 복사 (룰·hook·command·prompt)
#   - memory-templates/ → ~/.claude/projects/<slug>/memory/ 복사
#   - {{USER_NAME}} placeholder를 입력한 이름으로 치환
#   - settings.json 생성 (플러그인 26개 자동 enable)
#   - /check-rules 실행해서 16/16 PASS 검증
#   - 자동 설치 불가 영역(MCP 계정 연동) 안내

set -e

# ───────────────────────────────────────
# 0. 색깔·로그 함수
# ───────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log()  { echo -e "${BLUE}▶${NC} $*"; }
ok()   { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}⚠${NC}  $*"; }
err()  { echo -e "${RED}✗${NC} $*"; exit 1; }

trim() {
  printf '%s' "$1" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//'
}

count_files() {
  local glob="$1"
  local count
  count=$(find $glob -type f 2>/dev/null | wc -l | tr -d ' ')
  printf '%s' "${count:-0}"
}

replace_user_placeholder_in_file() {
  local target_file="$1"
  if grep -q "{{USER_NAME}}" "$target_file" 2>/dev/null; then
    JARVIS_USER_NAME="$USER_NAME" perl -0pi -e 's/\{\{USER_NAME\}\}/$ENV{JARVIS_USER_NAME}/g' "$target_file"
    PLACEHOLDER_REPLACED=$((PLACEHOLDER_REPLACED + 1))
  fi
}

replace_user_placeholders() {
  local target
  local md_file
  PLACEHOLDER_REPLACED=0

  TARGETS=(
    "$CLAUDE_DIR/CLAUDE.md"
    "$CLAUDE_DIR/RULES.md"
    "$CLAUDE_DIR/FLAGS.md"
    "$CLAUDE_DIR/AGENTS_SYSTEM.md"
    "$CLAUDE_DIR/AGENTS_REFERENCE.md"
    "$CLAUDE_DIR/modes"
    "$CLAUDE_DIR/rules"
    "$CLAUDE_DIR/commands"
    "$CLAUDE_DIR/prompts"
    "$CLAUDE_DIR/agents"
    "$MEM_DIR"
  )

  for target in "${TARGETS[@]}"; do
    if [[ -f "$target" ]]; then
      replace_user_placeholder_in_file "$target"
    elif [[ -d "$target" ]]; then
      while IFS= read -r -d '' md_file; do
        replace_user_placeholder_in_file "$md_file"
      done < <(find "$target" -type f -name "*.md" -print0)
    fi
  done
}

count_enabled_plugins() {
  SETTINGS_FILE="$CLAUDE_DIR/settings.json" python3 - <<'PY'
import json
import os
from pathlib import Path

settings = Path(os.environ["SETTINGS_FILE"])
if not settings.exists():
    print(0)
else:
    data = json.loads(settings.read_text())
    print(len(data.get("enabledPlugins", {})))
PY
}

verify_pass() {
  local name="$1"
  local detail="$2"
  echo "  ✅ [$name] $detail"
  VERIFY_PASS=$((VERIFY_PASS + 1))
}

verify_warn() {
  local name="$1"
  local detail="$2"
  echo "  ⚠️  [$name] $detail"
  VERIFY_WARN=$((VERIFY_WARN + 1))
}

verify_fail() {
  local name="$1"
  local detail="$2"
  echo "  ❌ [$name] $detail"
  VERIFY_FAIL=$((VERIFY_FAIL + 1))
}

# ───────────────────────────────────────
# 1. 시작 배너
# ───────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   JARVIS-OS v1.2 자동 설치"
echo "   제작: Ben(이치훈) · GitHub @jaechi-factory"
echo "   Repo: github.com/jaechi-factory/jarvis-os"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ───────────────────────────────────────
# 2. 사전 조건 확인
# ───────────────────────────────────────
log "[1/11] 사전 조건 확인"

if ! command -v claude &>/dev/null; then
  err "Claude Code CLI가 없습니다. https://claude.ai/code 에서 설치 후 다시 실행"
fi
ok "  Claude CLI 발견"

if ! command -v python3 &>/dev/null; then
  err "Python 3이 필요합니다 (hook 스크립트 동작에 사용). 'brew install python3' 또는 패키지 매니저로 설치"
fi
ok "  Python 3: $(python3 --version)"

if ! command -v git &>/dev/null; then
  err "Git이 필요합니다."
fi
ok "  Git: $(git --version | head -1)"

# ───────────────────────────────────────
# 3. 작업 위치 결정
# ───────────────────────────────────────
log "[2/11] 작업 위치 결정"

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# curl로 받았을 때는 SCRIPT_DIR가 stdin이 됨 → repo를 임시로 clone
if [[ ! -f "$SCRIPT_DIR/core/CLAUDE.md" ]]; then
  log "  로컬 source 없음 — 임시 디렉토리에 clone"
  TEMP_REPO=$(mktemp -d)
  git clone --depth=1 https://github.com/jaechi-factory/jarvis-os.git "$TEMP_REPO" 2>&1 | sed 's/^/    /'
  SCRIPT_DIR="$TEMP_REPO"
  CLEANUP_TEMP=1
fi
ok "  source: $SCRIPT_DIR"

# ───────────────────────────────────────
# 4. 이름 온보딩
# ───────────────────────────────────────
log "[3/11] 사용자 이름 온보딩"

echo "  JARVIS-OS는 Claude Code를 팀처럼 운영해주는 설정 묶음입니다."
echo "  룰/에이전트/훅/메모리/플러그인을 한 번에 깔고,"
echo "  설치 직후부터 자비스 호명 + 자동 검증 + 감사 로그가 동작합니다."
echo "  먼저 호명할 이름을 설정할게요."

DEFAULT_NAME="$(whoami)"
USER_NAME="${JARVIS_USER_NAME:-}"

if [[ -z "$USER_NAME" ]]; then
  printf "Enter your name: "
  read -r USER_NAME || true
fi

USER_NAME="$(trim "$USER_NAME")"
if [[ -z "$USER_NAME" ]]; then
  USER_NAME="$DEFAULT_NAME"
  warn "  이름 입력이 비어 있어 기본값($USER_NAME) 사용"
fi

ok "  호명 이름 설정: $USER_NAME"
ok "  인식 규칙: '자비스' + '$USER_NAME'"

# ───────────────────────────────────────
# 5. 기존 ~/.claude 백업
# ───────────────────────────────────────
log "[4/11] 기존 ~/.claude 백업"

if [[ -d "$CLAUDE_DIR" ]]; then
  BACKUP_DIR="${CLAUDE_DIR}.backup-$(date +%Y%m%d-%H%M%S)"
  cp -R "$CLAUDE_DIR" "$BACKUP_DIR"
  ok "  백업 완료: $BACKUP_DIR"
else
  mkdir -p "$CLAUDE_DIR"
  ok "  ~/.claude 신규 생성"
fi

# ───────────────────────────────────────
# 6. core/ 복사 (룰·hook·command·prompt)
# ───────────────────────────────────────
log "[5/11] OS 본체 복사 (core/)"

# 자동 로드 룰 5
cp "$SCRIPT_DIR"/core/CLAUDE.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/RULES.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/FLAGS.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/AGENTS_SYSTEM.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/AGENTS_REFERENCE.md "$CLAUDE_DIR/"
ok "  자동 로드 룰 5 파일"

# modes
mkdir -p "$CLAUDE_DIR/modes"
cp "$SCRIPT_DIR"/core/modes/*.md "$CLAUDE_DIR/modes/"
ok "  modes/ $(find "$CLAUDE_DIR/modes" -type f -name '*.md' | wc -l | tr -d ' ') 파일"

# rules/common
mkdir -p "$CLAUDE_DIR/rules/common"
cp "$SCRIPT_DIR"/core/rules/common/*.md "$CLAUDE_DIR/rules/common/"
ok "  rules/common/ $(find "$CLAUDE_DIR/rules/common" -type f -name '*.md' | wc -l | tr -d ' ') 파일"

# hooks (실행권한)
mkdir -p "$CLAUDE_DIR/hooks"
cp "$SCRIPT_DIR"/core/hooks/*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR"/hooks/*.sh
ok "  hooks/ $(find "$CLAUDE_DIR/hooks" -type f -name '*.sh' | wc -l | tr -d ' ') 파일 (실행권한 +x)"

# commands
mkdir -p "$CLAUDE_DIR/commands"
cp "$SCRIPT_DIR"/core/commands/*.md "$CLAUDE_DIR/commands/"
ok "  commands/ $(find "$CLAUDE_DIR/commands" -type f -name '*.md' | wc -l | tr -d ' ') 파일"

# agents
mkdir -p "$CLAUDE_DIR/agents"
cp "$SCRIPT_DIR"/core/agents/*.md "$CLAUDE_DIR/agents/"
ok "  agents/ $(find "$CLAUDE_DIR/agents" -type f -name '*.md' | wc -l | tr -d ' ') 파일"

# prompts
mkdir -p "$CLAUDE_DIR/prompts"
cp "$SCRIPT_DIR"/core/prompts/*.md "$CLAUDE_DIR/prompts/"
ok "  prompts/ $(find "$CLAUDE_DIR/prompts" -type f -name '*.md' | wc -l | tr -d ' ') 파일"

# ───────────────────────────────────────
# 7. 메모리 디렉토리 + 템플릿 복사
# ───────────────────────────────────────
log "[6/11] 메모리 템플릿 복사"

# slug 계산: HOME path → claude-mem 패턴
SLUG="${HOME//\//-}"
MEM_DIR="$CLAUDE_DIR/projects/$SLUG/memory"
mkdir -p "$MEM_DIR/global" "$MEM_DIR/projects"
ok "  메모리 디렉토리: $MEM_DIR"

cp "$SCRIPT_DIR"/memory-templates/global/*.md "$MEM_DIR/global/"
cp "$SCRIPT_DIR"/memory-templates/global/*.md.template "$MEM_DIR/global/" 2>/dev/null || true
ok "  global/ $(find "$MEM_DIR/global" -type f -name '*.md*' | wc -l | tr -d ' ') 파일 복사"

# user_profile.md.template → global/user_profile.md
if [[ ! -f "$MEM_DIR/global/user_profile.md" ]]; then
  if [[ -f "$MEM_DIR/global/user_profile.md.template" ]]; then
    cp "$MEM_DIR/global/user_profile.md.template" "$MEM_DIR/global/user_profile.md"
    rm -f "$MEM_DIR/global/user_profile.md.template"
    ok "  user_profile.md 빈 템플릿 생성"
  else
    warn "  user_profile.md.template 누락 (수동으로 작성 필요)"
  fi
else
  warn "  user_profile.md 이미 존재 — 보존"
  rm -f "$MEM_DIR/global/user_profile.md.template" 2>/dev/null || true
fi

# MEMORY.md.template → MEMORY.md
if [[ ! -f "$MEM_DIR/MEMORY.md" ]]; then
  cp "$SCRIPT_DIR"/memory-templates/MEMORY.md.template "$MEM_DIR/MEMORY.md"
  ok "  MEMORY.md 인덱스 골격"
else
  warn "  MEMORY.md 이미 존재 — 보존 (수동 병합 필요할 수 있음)"
fi

touch "$MEM_DIR/projects/.gitkeep"

# ───────────────────────────────────────
# 8. 사용자 이름 치환 + 호명 메모리 생성
# ───────────────────────────────────────
log "[7/11] 사용자 이름 치환 + 호명 설정"

replace_user_placeholders
ok "  {{USER_NAME}} 치환 완료: ${PLACEHOLDER_REPLACED} 파일"

USER_IDENTITY_FILE="$MEM_DIR/global/user_identity.md"
cat > "$USER_IDENTITY_FILE" <<EOF_IDENTITY
---
name: 사용자 호명 정보
description: 설치 시 입력한 사용자 이름과 기본 호명 규칙.
type: reference
revisedAt: $(date +%Y-%m-%d)
---
# 사용자 호명 정보

- 사용자 이름: $USER_NAME
- 사용자 호명 키워드: "$USER_NAME", "사용자"
- 시스템 호명 키워드: "자비스"
- 목적: 대화 시작 시 사용자 이름 인식 + 자비스 호명 동시 지원
EOF_IDENTITY
ok "  사용자 호명 메모리 생성: $USER_IDENTITY_FILE"

if ! grep -q "user_identity.md" "$MEM_DIR/MEMORY.md" 2>/dev/null; then
  printf '\n- [사용자 호명 정보](global/user_identity.md) — 설치 시 입력한 이름과 호명 규칙\n' >> "$MEM_DIR/MEMORY.md"
  ok "  MEMORY.md 인덱스에 user_identity.md 추가"
fi

# ───────────────────────────────────────
# 9. settings.json 생성
# ───────────────────────────────────────
log "[8/11] settings.json 생성 (플러그인/스킬)"

if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.before-jarvis-os"
  warn "  기존 settings.json → settings.json.before-jarvis-os로 백업"
fi

cp "$SCRIPT_DIR/settings.template.json" "$CLAUDE_DIR/settings.json"
PLUGIN_COUNT=$(count_enabled_plugins)
ok "  settings.json 생성 (enabledPlugins ${PLUGIN_COUNT}개)"
ok "  skill 번들 자동 활성: superpowers / pm-skills / designer-skills / ui-ux-pro-max"
ok "  defaultMode: acceptEdits (Edit/Write 자동 승인, Bash는 첫 호출 시 확인)"

# ───────────────────────────────────────
# 10. /check-rules 검증
# ───────────────────────────────────────
log "[9/11] 정합성 검증 (/check-rules)"

CHECK_RULES_PASS=0
if [[ -x "$CLAUDE_DIR/hooks/check-rules.sh" ]]; then
  echo ""
  CHECK_RULES_OUTPUT=$(bash "$CLAUDE_DIR/hooks/check-rules.sh" 2>&1 || true)
  echo "$CHECK_RULES_OUTPUT" | tail -22
  echo ""
  if echo "$CHECK_RULES_OUTPUT" | grep -q "PASS=16"; then
    CHECK_RULES_PASS=1
  fi
else
  warn "  check-rules.sh 누락 (수동 검증 필요)"
fi

# ───────────────────────────────────────
# 11. 설치 상태 자동 점검
# ───────────────────────────────────────
log "[10/11] 설치 상태 자동 점검"

VERIFY_PASS=0
VERIFY_WARN=0
VERIFY_FAIL=0

if [[ "$CHECK_RULES_PASS" -eq 1 ]]; then
  verify_pass "/check-rules" "16/16 PASS 확인"
else
  verify_warn "/check-rules" "16/16 PASS를 파싱하지 못함 (출력 확인 필요)"
fi

if command -v claude >/dev/null 2>&1 && [[ -d "$CLAUDE_DIR" ]] && [[ -d "$MEM_DIR" ]]; then
  verify_pass "CLI" "~/.claude 구조 + claude --version 준비됨"
else
  verify_fail "CLI" "Claude CLI 또는 설치 디렉토리 점검 필요"
fi

HOOK_TOTAL=$(find "$CLAUDE_DIR/hooks" -type f -name '*.sh' 2>/dev/null | wc -l | tr -d ' ')
HOOK_EXEC=$(find "$CLAUDE_DIR/hooks" -type f -name '*.sh' -perm -u=x 2>/dev/null | wc -l | tr -d ' ')
if [[ "${HOOK_TOTAL:-0}" -gt 0 && "${HOOK_TOTAL:-0}" -eq "${HOOK_EXEC:-0}" ]]; then
  verify_pass "Hook" "${HOOK_EXEC}개 실행 권한 확인"
else
  verify_fail "Hook" "hook 파일/실행권한 불일치 (total=${HOOK_TOTAL:-0}, exec=${HOOK_EXEC:-0})"
fi

RULE_TOTAL=$(find "$CLAUDE_DIR/rules/common" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
CMD_TOTAL=$(find "$CLAUDE_DIR/commands" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
AGENT_TOTAL=$(find "$CLAUDE_DIR/agents" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
MODE_TOTAL=$(find "$CLAUDE_DIR/modes" -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "${RULE_TOTAL:-0}" -ge 7 && "${CMD_TOTAL:-0}" -ge 1 && "${AGENT_TOTAL:-0}" -ge 30 && "${MODE_TOTAL:-0}" -ge 8 ]]; then
  verify_pass "Rules/Commands/Agents/Modes" "rules=${RULE_TOTAL}, commands=${CMD_TOTAL}, agents=${AGENT_TOTAL}, modes=${MODE_TOTAL}"
else
  verify_fail "Rules/Commands/Agents/Modes" "복사 수량이 기대치 미달 (rules=${RULE_TOTAL}, commands=${CMD_TOTAL}, agents=${AGENT_TOTAL}, modes=${MODE_TOTAL})"
fi

if [[ "${PLUGIN_COUNT:-0}" -ge 26 ]]; then
  verify_pass "Plugin" "enabledPlugins ${PLUGIN_COUNT}개"
else
  verify_fail "Plugin" "enabledPlugins 수량 부족 (${PLUGIN_COUNT:-0})"
fi

SKILL_BUNDLE_OK=$(CLAUDE_DIR="$CLAUDE_DIR" python3 - <<'PY'
import json
import os
from pathlib import Path
p = Path(os.environ["CLAUDE_DIR"]) / "settings.json"
if not p.exists():
    print("FAIL")
else:
    keys = set(json.loads(p.read_text()).get("enabledPlugins", {}).keys())
    required = [
        "superpowers@claude-plugins-official",
        "pm-toolkit@pm-skills",
        "design-research@designer-skills",
        "ui-ux-pro-max@ui-ux-pro-max-skill",
    ]
    print("OK" if all(r in keys for r in required) else "FAIL")
PY
)
if [[ "$SKILL_BUNDLE_OK" = "OK" ]]; then
  verify_pass "Skill" "superpowers/pm-skills/designer-skills/ui-ux-pro-max 활성 확인"
else
  verify_fail "Skill" "핵심 skill 번들 활성 상태 확인 필요"
fi

PLACEHOLDER_LEFT=$(rg -n -F "{{USER_NAME}}" "$CLAUDE_DIR" "$MEM_DIR" -g "*.md" 2>/dev/null | wc -l | tr -d ' ')
if [[ "${PLACEHOLDER_LEFT:-0}" -eq 0 ]] && grep -q "$USER_NAME" "$CLAUDE_DIR/CLAUDE.md" && grep -q "$USER_NAME" "$USER_IDENTITY_FILE"; then
  verify_pass "사용자 이름 호명 테스트" "\"$USER_NAME 누구야?\" 질의에 필요한 이름/호명 컨텍스트 준비 완료"
else
  verify_fail "사용자 이름 호명 테스트" "placeholder 잔존 또는 이름 치환 누락 (left=${PLACEHOLDER_LEFT:-0})"
fi

MCP_LIST_OUTPUT=$(claude mcp list 2>&1 || true)
if [[ -n "$MCP_LIST_OUTPUT" ]] && echo "$MCP_LIST_OUTPUT" | grep -qiE "codex|github|figma"; then
  verify_pass "MCP" "claude mcp list에서 codex/github/figma 감지"
else
  verify_warn "MCP" "mcp 연결은 계정/토큰 연동 후 수동 확인 필요 (claude mcp list)"
fi

echo ""
echo "  결과: PASS=$VERIFY_PASS · WARN=$VERIFY_WARN · FAIL=$VERIFY_FAIL"

# ───────────────────────────────────────
# 12. 마무리 안내
# ───────────────────────────────────────
log "[11/11] 설치 완료"

# 임시 clone 정리
if [[ -n "${CLEANUP_TEMP:-}" ]]; then
  rm -rf "$TEMP_REPO"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ JARVIS-OS v1.2 설치 완료"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "▶ 자동 설치된 영역"
echo "  - CLI 구조: ~/.claude + projects/$SLUG/memory"
echo "  - Hooks: core/hooks → ~/.claude/hooks (+x 권한)"
echo "  - Rules/Commands/Agents/Prompts/Modes: core/* → ~/.claude/*"
echo "  - MD 템플릿: {{USER_NAME}} → '$USER_NAME' 치환 후 배치"
echo "  - Memory templates: memory-templates → ~/.claude/projects/$SLUG/memory"
echo "  - Plugins(26): settings.json enabledPlugins 자동 구성"
echo "  - Skills: superpowers / pm-skills / designer-skills 등 자동 활성"
echo ""
echo "▶ 사용자 직접 설정이 필요한 영역 (자동 불가)"
echo "  1. GitHub MCP 토큰 발급/연결"
echo "     - 발급 URL: https://github.com/settings/personal-access-tokens/new"
echo "     - 권한 설정 후 Claude MCP 설정에서 github 서버 연결"
echo "  2. Figma 계정 연동"
echo "     - 토큰 URL: https://www.figma.com/developers/api"
echo "     - figma MCP 연결 후 파일 접근 권한 승인"
echo "  3. Codex CLI 설치 (미설치 시)"
echo "     - npm install -g @openai/codex"
echo "  4. MCP 서버 등록 확인"
echo "     - claude mcp list"
echo "     - 필요 시 codex-cli / github / figma 서버를 수동 추가"
echo ""
echo "▶ 다음 단계"
echo "  1. Claude Code 재시작 (현재 세션 종료 후 다시 'claude')"
echo "  2. 프로필 작성: $MEM_DIR/global/user_profile.md"
echo "  3. 첫 인사: \"자비스, 안녕\" 또는 \"$USER_NAME 누구야?\""
echo ""
echo "▶ 백업 위치"
if [[ -n "${BACKUP_DIR:-}" ]]; then
  echo "  $BACKUP_DIR"
fi
echo ""

exit 0
