#!/usr/bin/env bash
# JARVIS-OS v1.0 — 자동 설치 스크립트
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
#   - memory-templates/ → ~/.claude/projects/<slug>/memory/ 복사 (개인 정보 없는 ABSOLUTE/룰)
#   - settings.json 생성 (플러그인 26개 자동 enable)
#   - /check-rules 실행해서 16/16 PASS 검증
#   - 다음 단계 안내

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

# ───────────────────────────────────────
# 1. 시작 배너
# ───────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "   JARVIS-OS v1.0 자동 설치"
echo "   ben의 Claude Code 운영체계"
echo "   GitHub: jaechi-factory/jarvis-os"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ───────────────────────────────────────
# 2. 사전 조건 확인
# ───────────────────────────────────────
log "[1/8] 사전 조건 확인"

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
log "[2/8] 작업 위치 결정"

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
# 4. 기존 ~/.claude 백업
# ───────────────────────────────────────
log "[3/8] 기존 ~/.claude 백업"

if [[ -d "$CLAUDE_DIR" ]]; then
  BACKUP_DIR="${CLAUDE_DIR}.backup-$(date +%Y%m%d-%H%M%S)"
  cp -R "$CLAUDE_DIR" "$BACKUP_DIR"
  ok "  백업 완료: $BACKUP_DIR"
else
  mkdir -p "$CLAUDE_DIR"
  ok "  ~/.claude 신규 생성"
fi

# ───────────────────────────────────────
# 5. core/ 복사 (룰·hook·command·prompt)
# ───────────────────────────────────────
log "[4/8] OS 본체 복사 (core/)"

# 자동 로드 룰 5
cp "$SCRIPT_DIR"/core/CLAUDE.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/RULES.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/FLAGS.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/AGENTS_SYSTEM.md "$CLAUDE_DIR/"
cp "$SCRIPT_DIR"/core/AGENTS_REFERENCE.md "$CLAUDE_DIR/"
ok "  자동 로드 룰 5 파일"

# modes 9
mkdir -p "$CLAUDE_DIR/modes"
cp "$SCRIPT_DIR"/core/modes/*.md "$CLAUDE_DIR/modes/"
ok "  modes/ $(ls "$CLAUDE_DIR"/modes/ | wc -l | tr -d ' ') 파일"

# rules/common 9
mkdir -p "$CLAUDE_DIR/rules/common"
cp "$SCRIPT_DIR"/core/rules/common/*.md "$CLAUDE_DIR/rules/common/"
ok "  rules/common/ $(ls "$CLAUDE_DIR"/rules/common/ | wc -l | tr -d ' ') 파일"

# hooks 8 (실행권한)
mkdir -p "$CLAUDE_DIR/hooks"
cp "$SCRIPT_DIR"/core/hooks/*.sh "$CLAUDE_DIR/hooks/"
chmod +x "$CLAUDE_DIR"/hooks/*.sh
ok "  hooks/ $(ls "$CLAUDE_DIR"/hooks/*.sh | wc -l | tr -d ' ') 파일 (실행권한 +x)"

# commands 2 (우리가 만든 것만)
mkdir -p "$CLAUDE_DIR/commands"
cp "$SCRIPT_DIR"/core/commands/*.md "$CLAUDE_DIR/commands/"
ok "  commands/ $(ls "$CLAUDE_DIR"/commands/ | wc -l | tr -d ' ') 파일"

# agents 38 (L3 Leader 본체 — 5단 조직 작동에 필수)
mkdir -p "$CLAUDE_DIR/agents"
cp "$SCRIPT_DIR"/core/agents/*.md "$CLAUDE_DIR/agents/"
ok "  agents/ $(ls "$CLAUDE_DIR"/agents/ | wc -l | tr -d ' ') 파일 (L3 Leader)"

# prompts 1
mkdir -p "$CLAUDE_DIR/prompts"
cp "$SCRIPT_DIR"/core/prompts/*.md "$CLAUDE_DIR/prompts/"
ok "  prompts/ux-writer.md (78KB SSOT)"

# ───────────────────────────────────────
# 6. 메모리 디렉토리 + ABSOLUTE/룰 복사
# ───────────────────────────────────────
log "[5/8] 메모리 디렉토리 + ABSOLUTE/룰"

# slug 계산: HOME path → claude-mem 패턴
# /Users/john → -Users-john
SLUG="${HOME//\//-}"
MEM_DIR="$CLAUDE_DIR/projects/$SLUG/memory"
mkdir -p "$MEM_DIR/global" "$MEM_DIR/projects"
ok "  메모리 디렉토리: $MEM_DIR"

# global/ ABSOLUTE/룰 파일 (개인 정보 제거됨)
cp "$SCRIPT_DIR"/memory-templates/global/*.md "$MEM_DIR/global/"
# .template 확장자 파일도 복사 (user_profile.md.template 등)
cp "$SCRIPT_DIR"/memory-templates/global/*.md.template "$MEM_DIR/global/" 2>/dev/null || true
ok "  global/ $(ls "$MEM_DIR"/global/*.md 2>/dev/null | wc -l | tr -d ' ') 파일 복사"

# user_profile.md.template → global/user_profile.md (사용자 작성용)
if [[ ! -f "$MEM_DIR/global/user_profile.md" ]]; then
  if [[ -f "$MEM_DIR/global/user_profile.md.template" ]]; then
    cp "$MEM_DIR/global/user_profile.md.template" "$MEM_DIR/global/user_profile.md"
    rm -f "$MEM_DIR/global/user_profile.md.template"
    ok "  user_profile.md 빈 템플릿 (사용자 직접 작성 필요)"
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

# projects/ 빈
touch "$MEM_DIR/projects/.gitkeep"

# ───────────────────────────────────────
# 7. settings.json 생성
# ───────────────────────────────────────
log "[6/8] settings.json 생성"

if [[ -f "$CLAUDE_DIR/settings.json" ]]; then
  cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.before-jarvis-os"
  warn "  기존 settings.json → settings.json.before-jarvis-os로 백업"
fi

cp "$SCRIPT_DIR/settings.template.json" "$CLAUDE_DIR/settings.json"
ok "  settings.json 생성 (플러그인 26개 enable + hook 등록)"
ok "  defaultMode: acceptEdits (Edit/Write 자동 승인, Bash는 첫 호출 시 확인)"

# ───────────────────────────────────────
# 8. /check-rules 검증
# ───────────────────────────────────────
log "[7/8] 정합성 검증 (/check-rules)"

if [[ -x "$CLAUDE_DIR/hooks/check-rules.sh" ]]; then
  echo ""
  bash "$CLAUDE_DIR/hooks/check-rules.sh" 2>&1 | tail -22
  echo ""
else
  warn "  check-rules.sh 누락 (이상 — 수동 검증 필요)"
fi

# ───────────────────────────────────────
# 9. 마무리 안내
# ───────────────────────────────────────
log "[8/8] 설치 완료"

# 임시 clone 정리
if [[ -n "${CLEANUP_TEMP:-}" ]]; then
  rm -rf "$TEMP_REPO"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ JARVIS-OS v1.0 설치 완료"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "▶ 다음 단계:"
echo ""
echo "  1. Claude Code 재시작 (현재 세션 끝내고 다시 'claude' 실행)"
echo ""
echo "  2. 본인 프로필 작성:"
echo "     $MEM_DIR/global/user_profile.md"
echo "     (자비스가 첫 세션에서 안내해줌)"
echo ""
echo "  3. 자비스에게 첫 인사:"
echo '     "자비스, 안녕"'
echo "     → 5블록 리포트 + 자동 푸터로 응답"
echo ""
echo "▶ 백업 위치 (사고 시 복구):"
if [[ -n "${BACKUP_DIR:-}" ]]; then
  echo "  $BACKUP_DIR"
fi
echo ""
echo "▶ 도움말:"
echo "  - GitHub: https://github.com/jaechi-factory/jarvis-os"
echo "  - 룰 점검: '자비스, 룰 점검해' (또는 /check-rules 직접)"
echo "  - 도구 호출 추적: '자비스, /trace verify'"
echo ""

exit 0
