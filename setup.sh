#!/bin/bash
# Claude Code 환경 재설치 스크립트
# 새 PC / 새 계정에서 실행
# 실행: bash ~/.claude/setup.sh

set -e

CLAUDE_DIR="$HOME/.claude"
USERNAME=$(whoami)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Code 환경 설치 시작"
echo "  사용자: $USERNAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ───────────────────────────────────────
# 0. 전제 조건 확인
# ───────────────────────────────────────
echo "[0/5] 전제 조건 확인..."

if ! command -v claude &>/dev/null; then
  echo "  ❌ Claude Code CLI가 설치되어 있지 않습니다."
  echo "     설치: https://claude.ai/code 에서 다운로드"
  exit 1
fi

if ! command -v node &>/dev/null; then
  echo "  ❌ Node.js가 필요합니다. 먼저 설치하세요."
  exit 1
fi

echo "  ✅ Claude CLI: $(claude --version 2>/dev/null || echo 'version unknown')"
echo "  ✅ Node.js: $(node --version)"

# ───────────────────────────────────────
# 1. claude-mem 플러그인 설치
# ───────────────────────────────────────
echo ""
echo "[1/5] claude-mem 플러그인 설치..."

PLUGIN_DIR="$CLAUDE_DIR/plugins/marketplaces/thedotmack/plugin"

if [ -d "$PLUGIN_DIR" ]; then
  echo "  (이미 설치됨 — 건너뜀)"
else
  git clone https://github.com/thedotmack/claude-mem.git /tmp/claude-mem --depth=1
  mkdir -p "$PLUGIN_DIR"
  cp -r /tmp/claude-mem/plugin/. "$PLUGIN_DIR/"
  rm -rf /tmp/claude-mem
  echo "  ✅ claude-mem 설치 완료"
fi

# ───────────────────────────────────────
# 2. MCP 서버 설치
# ───────────────────────────────────────
echo ""
echo "[2/5] MCP 서버 설치..."

install_mcp() {
  local name=$1
  local cmd=$2
  if claude mcp list 2>/dev/null | grep -q "^$name"; then
    echo "  (이미 설치됨: $name — 건너뜀)"
  else
    eval "claude mcp add --scope user $cmd"
    echo "  ✅ $name 설치 완료"
  fi
}

install_mcp "context7" "context7 -- npx -y @upstash/context7-mcp"
install_mcp "sequential-thinking" "sequential-thinking -- npx -y @modelcontextprotocol/server-sequential-thinking"

# ───────────────────────────────────────
# 3. agents 파일 복사
# ───────────────────────────────────────
echo ""
echo "[3/5] Agent 파일 설치..."

# 이 스크립트가 claude-setup repo 안에 있을 경우:
#   SETUP_REPO_DIR="$(dirname "$0")"
#   cp "$SETUP_REPO_DIR/agents/"*.md "$CLAUDE_DIR/agents/"
#
# 이 스크립트가 ~/.claude/에 단독으로 있을 경우:
#   agents 파일이 이미 ~/.claude/agents/에 있으면 건너뜀

AGENTS_DIR="$CLAUDE_DIR/agents"
mkdir -p "$AGENTS_DIR"

REQUIRED_AGENTS=(
  "product-planner.md"
  "product-ux-reviewer.md"
  "safe-implementer.md"
  "product-qa-checker.md"
)

missing=0
for agent in "${REQUIRED_AGENTS[@]}"; do
  if [ -f "$AGENTS_DIR/$agent" ]; then
    echo "  ✅ $agent"
  else
    echo "  ❌ $agent 없음 — claude-setup repo에서 복사 필요"
    missing=$((missing + 1))
  fi
done

if [ $missing -gt 0 ]; then
  echo ""
  echo "  ⚠️  누락된 agent 파일이 있습니다."
  echo "     claude-setup repo clone 후 agents/ 폴더를 ~/.claude/agents/에 복사하세요."
fi

# ───────────────────────────────────────
# 4. settings.json 초기화 (없을 때만)
# ───────────────────────────────────────
echo ""
echo "[4/5] settings.json 확인..."

SETTINGS_FILE="$CLAUDE_DIR/settings.json"
TEMPLATE_FILE="$CLAUDE_DIR/settings.template.json"

if [ -f "$SETTINGS_FILE" ]; then
  echo "  (이미 존재 — 건너뜀. 수동으로 template과 비교 후 병합 권장)"
else
  if [ -f "$TEMPLATE_FILE" ]; then
    cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
    echo "  ✅ settings.template.json → settings.json 복사 완료"
    echo "  ⚠️  작업 프로젝트 경로를 permissions.allow에 추가하세요:"
    echo "       Read(/Users/$USERNAME/{프로젝트명}/**)"
    echo "       Write(/Users/$USERNAME/{프로젝트명}/**)"
    echo "       Edit(/Users/$USERNAME/{프로젝트명}/**)"
  else
    echo "  ❌ settings.template.json이 없습니다. 수동 설정 필요."
  fi
fi

# ───────────────────────────────────────
# 5. 완료 요약
# ───────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  설치 완료"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "다음 단계:"
echo "  1. settings.json에 작업 프로젝트 경로 추가"
echo "  2. 각 프로젝트 .claude/CLAUDE.md 생성"
echo "  3. Claude Code 재시작 후 확인"
echo ""
echo "claude-setup repo 구조 (권장):"
echo "  claude-setup/"
echo "  ├── agents/           ← ~/.claude/agents/ 로 복사"
echo "  ├── CLAUDE.md         ← ~/.claude/CLAUDE.md 참고본"
echo "  ├── settings.template.json"
echo "  └── setup.sh          ← 이 파일"
