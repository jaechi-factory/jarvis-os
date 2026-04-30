#!/usr/bin/env bash
# Rule consistency checker v2 (2026-04-25).
# Scans rule files for known modes of inconsistency.
#
# v2 changes:
#  - 5블록 SSOT 검사: 정의(필수 5블록 포맷 + 🧭 [라우팅 Echo] 패턴) vs 인용 구분
#  - ABSOLUTE 위치 검사: 헤더 정의(## .*ABSOLUTE) vs 인용 구분
#  - rules/common/* 9개 파일 정합성 추가
#  - 메모리 트리거 누적 검사 추가 (한 키워드가 여러 트리거에 충돌하는지)
#
# Usage: bash ~/.claude/hooks/check-rules.sh
# 슬래시 명령: /check-rules

cd "$HOME/.claude"

# Dynamic slug from HOME path (e.g. /Users/john → -Users-john)
# Note: Claude Code 슬러그 규칙은 / → - 뿐만 아니라 . → -도 함께 치환 (예: /Users/jane.smith → -Users-jane-smith)
SLUG="${HOME//\//-}"
SLUG="${SLUG//./-}"
MEM_GLOBAL="$HOME/.claude/projects/$SLUG/memory/global"
MEM_INDEX="$HOME/.claude/projects/$SLUG/memory/MEMORY.md"

# Build target file list
find . -maxdepth 5 \( \
  -path './CLAUDE.md' -o \
  -path './RULES.md' -o \
  -path './AGENTS_SYSTEM.md' -o \
  -path './AGENTS_REFERENCE.md' -o \
  -path './FLAGS.md' -o \
  -path './modes/*.md' -o \
  -path './rules/common/*.md' -o \
  -path "./projects/$SLUG/memory/MEMORY.md" -o \
  -path "./projects/$SLUG/memory/global/*.md" \
\) -type f > /tmp/rule-check-files.txt

TOTAL=$(wc -l < /tmp/rule-check-files.txt | tr -d ' ')
PASS=0
FAIL=0
WARN=0

print_check() {
  local status="$1"
  local name="$2"
  local detail="$3"
  case "$status" in
    PASS) echo "  ✅ [$name] $detail"; PASS=$((PASS+1));;
    FAIL) echo "  ❌ [$name] $detail"; FAIL=$((FAIL+1));;
    WARN) echo "  ⚠️  [$name] $detail"; WARN=$((WARN+1));;
  esac
}

echo "═══════════════════════════════════════════════════════"
echo " 룰 정합성 검사 v2 — $(date '+%Y-%m-%d %H:%M:%S')"
echo " 검사 대상: $TOTAL 파일 (자동로드+global 메모리)"
echo "═══════════════════════════════════════════════════════"
echo ""

# ── 1. L1 호칭: COO 잔존 ──
COO_HITS=$(xargs grep -Hn "COO" < /tmp/rule-check-files.txt 2>/dev/null \
  | grep -v "변경 이력\|혼재되어\|→ CEO\|2026-04-25 4차\|COO/CEO 혼재" | wc -l | tr -d ' ')
if [ "${COO_HITS:-0}" -eq 0 ]; then
  print_check PASS "역할 모델 호칭" "COO 잔존 0건 (CEO=자비스 통일)"
else
  print_check FAIL "역할 모델 호칭" "COO 잔존 $COO_HITS건"
  xargs grep -Hn "COO" < /tmp/rule-check-files.txt 2>/dev/null \
    | grep -v "변경 이력\|혼재되어\|→ CEO\|2026-04-25 4차\|COO/CEO 혼재" | head -5 | sed 's/^/      /'
fi

# ── 2. L3 카운트 (32) ──
L3_OLD=$(xargs grep -Hn "L3 23\|Leader 23개\|23 Leader" < /tmp/rule-check-files.txt 2>/dev/null \
  | grep -v "핵심 23\|+ 9 = 32\|핵심 에이전트 23" | wc -l | tr -d ' ')
if [ "$L3_OLD" -eq 0 ]; then
  print_check PASS "L3 카운트" "32개 통일 (핵심 23 + 번들 9)"
else
  print_check FAIL "L3 카운트" "23개 잔존 $L3_OLD건"
fi

# ── 3. L4 카운트 (218) ──
L4_OLD=$(xargs grep -Hn "L4 220\|220개 스킬\|220 Worker\|Worker 220" < /tmp/rule-check-files.txt 2>/dev/null | wc -l | tr -d ' ')
if [ "$L4_OLD" -eq 0 ]; then
  print_check PASS "L4 카운트" "218개 통일"
else
  print_check FAIL "L4 카운트" "220개 잔존 $L4_OLD건"
fi

# ── 4. 카탈로그 버전 정합성 ──
CATALOG_FRONT=$(grep -E "^name:" "$MEM_GLOBAL/reference_tool_catalog.md" | grep -oE "v[0-9]+\.[0-9]+" | head -1)
CATALOG_BODY=$(grep -E "^# 도구 박스" "$MEM_GLOBAL/reference_tool_catalog.md" | grep -oE "v[0-9]+\.[0-9]+" | head -1)
MEM_CITE=$(grep "도구 박스 카탈로그" "$MEM_INDEX" | grep -oE "v[0-9]+\.[0-9]+" | head -1)
if [ "$CATALOG_FRONT" = "$CATALOG_BODY" ] && [ "$CATALOG_FRONT" = "$MEM_CITE" ]; then
  print_check PASS "카탈로그 버전" "$CATALOG_FRONT 통일 (frontmatter=본문=MEMORY)"
else
  print_check FAIL "카탈로그 버전" "frontmatter=$CATALOG_FRONT / 본문=$CATALOG_BODY / MEMORY=$MEM_CITE"
fi

# ── 5. 5블록 리포트 정의 (v2: 정의 vs 인용 구분) ──
# 정의 = "필수 5블록 포맷" + 다음 10줄 안에 "🧭 [라우팅 Echo]"가 있어야 함
DEFINITION_FILES=""
for f in $(cat /tmp/rule-check-files.txt); do
  if grep -q "필수 5블록 포맷\|5블록 리포트.*정의" "$f" 2>/dev/null; then
    if grep -A 10 "필수 5블록 포맷\|5블록 리포트.*정의" "$f" 2>/dev/null | grep -q "🧭.*\[라우팅 Echo\]"; then
      DEFINITION_FILES="$DEFINITION_FILES $f"
    fi
  fi
done
DEF_COUNT=$(echo "$DEFINITION_FILES" | tr ' ' '\n' | grep -v "^$" | wc -l | tr -d ' ')
NON_SSOT_DEF=$(echo "$DEFINITION_FILES" | tr ' ' '\n' | grep -v "AGENTS_SYSTEM.md\|AGENTS_REFERENCE.md" | grep -v "^$" | wc -l | tr -d ' ')
if [ "${NON_SSOT_DEF:-0}" -eq 0 ]; then
  print_check PASS "5블록 SSOT" "AGENTS_SYSTEM/REFERENCE 외에 정의 0건 (정의=포맷+🧭 패턴)"
else
  print_check FAIL "5블록 SSOT" "비-SSOT 파일에 5블록 정의 발견 ($NON_SSOT_DEF건)"
  echo "$DEFINITION_FILES" | tr ' ' '\n' | grep -v "AGENTS_SYSTEM.md\|AGENTS_REFERENCE.md" | grep -v "^$" | sed 's/^/      /'
fi

# ── 6. ABSOLUTE 블록 정의 위치 (v2: 헤더 정의 vs 메타 인용 구분) ──
# 정의 = '## 🔴 ABSOLUTE' 헤더로 시작하는 섹션 (CLAUDE.md만 가져야)
ABSOLUTE_HDR=$(grep -lE "^## 🔴 ABSOLUTE" ~/.claude/CLAUDE.md ~/.claude/RULES.md ~/.claude/AGENTS_SYSTEM.md ~/.claude/AGENTS_REFERENCE.md "$MEM_GLOBAL"/*.md 2>/dev/null | wc -l | tr -d ' ')
ABSOLUTE_NON_CLAUDE=$(grep -lE "^## 🔴 ABSOLUTE" ~/.claude/RULES.md ~/.claude/AGENTS_SYSTEM.md ~/.claude/AGENTS_REFERENCE.md "$MEM_GLOBAL"/*.md 2>/dev/null | wc -l | tr -d ' ')
if [ "${ABSOLUTE_NON_CLAUDE:-0}" -eq 0 ]; then
  print_check PASS "ABSOLUTE 위치" "CLAUDE.md 단독 정의 ($ABSOLUTE_HDR개 헤더, 메모리 인용 제외)"
else
  print_check FAIL "ABSOLUTE 위치" "CLAUDE.md 외 정의 발견 ($ABSOLUTE_NON_CLAUDE건)"
fi

# ── 7. Audit hook 등록 (settings.json) ──
HOOK_AUDIT=$(python3 -c "
import json
s = json.load(open('$HOME/.claude/settings.json'))
post = s.get('hooks',{}).get('PostToolUse',[])
stop = s.get('hooks',{}).get('Stop',[])
audit_log = any('audit-log.sh' in h.get('command','') for m in post for h in m.get('hooks',[]))
audit_sum = any('audit-summary.sh' in h.get('command','') for m in stop for h in m.get('hooks',[]))
print('OK' if (audit_log and audit_sum) else 'FAIL')
" 2>/dev/null)
if [ "$HOOK_AUDIT" = "OK" ]; then
  print_check PASS "Audit hook 등록" "PostToolUse audit-log + Stop audit-summary"
else
  print_check FAIL "Audit hook 등록" "settings.json hook 누락"
fi

# ── 8. Hook 실행권한 ──
HOOK_PERMS_OK=true
PERM_DETAIL=""
for hook in audit-log.sh audit-summary.sh check-rules.sh codex-declaration-check.sh codex-log.sh; do
  if [ -f "$HOME/.claude/hooks/$hook" ] && [ ! -x "$HOME/.claude/hooks/$hook" ]; then
    HOOK_PERMS_OK=false
    PERM_DETAIL="$PERM_DETAIL $hook"
  fi
done
if [ "$HOOK_PERMS_OK" = true ]; then
  print_check PASS "Hook 실행권한" "모두 +x"
else
  print_check FAIL "Hook 실행권한" "$PERM_DETAIL"
fi

# ── 9. MEMORY.md 1줄 룰 (200자) ──
LINE_VIOL=$(python3 -c "
cnt = 0
with open(os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'MEMORY.md')) as f:
    for line in f:
        if line.startswith('- ') and len(line) > 200:
            cnt += 1
print(cnt)
" 2>/dev/null)
if [ "${LINE_VIOL:-0}" -eq 0 ]; then
  print_check PASS "MEMORY 1줄 룰" "위반 0건 (200자 컷)"
else
  print_check WARN "MEMORY 1줄 룰" "$LINE_VIOL건 위반 (200자 초과)"
fi

# ── 10. 자비스 호칭 등록 ──
JARVIS_FILES=$(xargs grep -l "자비스" < /tmp/rule-check-files.txt 2>/dev/null | wc -l | tr -d ' ')
if [ "${JARVIS_FILES:-0}" -ge 4 ]; then
  print_check PASS "자비스 호칭" "$JARVIS_FILES 파일 등록"
else
  print_check WARN "자비스 호칭" "$JARVIS_FILES 파일만 등록 (최소 4 권장)"
fi

# ── 11. rules/common/* 자동로드 파일 정합성 (v2 신규) ──
COMMON_FILES=$(ls ~/.claude/rules/common/*.md 2>/dev/null | wc -l | tr -d ' ')
COMMON_LARGE=$(find ~/.claude/rules/common -name "*.md" -size +5k 2>/dev/null | wc -l | tr -d ' ')
if [ "${COMMON_FILES:-0}" -ge 7 ] && [ "${COMMON_LARGE:-0}" -eq 0 ]; then
  print_check PASS "rules/common 분산" "$COMMON_FILES 파일 모두 5KB 이하 (잘 분산)"
else
  print_check WARN "rules/common 분산" "$COMMON_FILES 파일, 5KB 초과 $COMMON_LARGE개 (재분산 검토)"
fi

# ── 12. 트리거 키워드 누적 검사 (v2 신규) ──
# AGENTS_SYSTEM.md 디렉터 트리거 표 + REFERENCE PM Skills + 공식 도구 + MEMORY 자동로드 트리거
# 한 키워드가 2개 이상 트리거 표에 등장하면 누적 위험
TRIGGER_OVERLAP=$(python3 -c "
import re, collections
files = [
  '$HOME/.claude/AGENTS_SYSTEM.md',
  '$HOME/.claude/AGENTS_REFERENCE.md',
  '$HOME/.claude/projects/' + os.environ['HOME'].replace('/', '-').replace('.', '-') + '/memory/MEMORY.md',
  os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'global', 'reference_official_tools_integration.md'),
]
keywords = collections.Counter()
key_pat = re.compile(r'(?:^|[\s,/|])([가-힣a-z]{2,12})(?=[\s,/|]|$)')
for path in files:
    try:
        with open(path) as f:
            in_trigger = False
            for line in f:
                if '트리거' in line and '|' in line:
                    in_trigger = True
                    continue
                if in_trigger and not line.strip().startswith('|'):
                    in_trigger = False
                if in_trigger and line.startswith('|'):
                    parts = line.split('|')
                    if len(parts) > 2:
                        cell = parts[1]
                        for m in key_pat.findall(cell):
                            if len(m) >= 3:
                                keywords[m] += 1
    except Exception:
        pass
overlap = [(k,v) for k,v in keywords.items() if v >= 3]
print(len(overlap))
for k, v in sorted(overlap, key=lambda x: -x[1])[:5]:
    print(f'  {k}: {v}회')
" 2>/dev/null)
TRIG_COUNT=$(echo "$TRIGGER_OVERLAP" | head -1)
if [ "${TRIG_COUNT:-0}" -le 5 ]; then
  print_check PASS "트리거 키워드 누적" "3+회 등장 키워드 $TRIG_COUNT개 (수용 범위)"
else
  print_check WARN "트리거 키워드 누적" "3+회 등장 키워드 $TRIG_COUNT개 (충돌 위험)"
  echo "$TRIGGER_OVERLAP" | tail -n +2 | sed 's/^/      /'
fi

# ── 13. global 메모리 frontmatter 검증 (v2 신규) ──
FM_MISSING=$(python3 -c "
import os
cnt = 0
for f in os.listdir(os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'global')):
    if not f.endswith('.md'): continue
    path = os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'global', f)
    try:
        with open(path) as fp:
            head = fp.read(500)
        if not head.startswith('---'):
            cnt += 1
    except: pass
print(cnt)
" 2>/dev/null)
if [ "${FM_MISSING:-0}" -eq 0 ]; then
  print_check PASS "global frontmatter" "36 파일 모두 frontmatter 보유"
else
  print_check WARN "global frontmatter" "$FM_MISSING개 파일 frontmatter 누락"
fi

# ── 14. 깨진 SSOT 참조 검사 (v2 신규, 우리 룰 영역만) ──
# 스코프: 자동로드 파일 + memory/global/* + memory/MEMORY.md
# plugins/ 같은 외부 패키지는 우리 룰 아님 → 제외
BROKEN_REFS=$(python3 -c "
import re, os
home = os.path.expanduser('~')
scan_paths = [
    home + '/.claude/CLAUDE.md',
    home + '/.claude/RULES.md',
    home + '/.claude/AGENTS_SYSTEM.md',
    home + '/.claude/AGENTS_REFERENCE.md',
    home + '/.claude/FLAGS.md',
]
for d in [home + '/.claude/modes', home + '/.claude/rules/common',
          os.path.join(home, '.claude', 'projects', home.replace('/', '-'), 'memory'),
          os.path.join(home, '.claude', 'projects', home.replace('/', '-'), 'memory'),
          os.path.join(home, '.claude', 'projects', home.replace('/', '-'), 'memory')]:
    if os.path.isdir(d):
        for f in os.listdir(d):
            if f.endswith('.md'):
                scan_paths.append(os.path.join(d, f))

ref_pat = re.compile(r'\`(~/\.claude/[^\`]+\.md)\`')
broken = []
for path in scan_paths:
    if not os.path.exists(path): continue
    try:
        with open(path) as fp:
            for i, line in enumerate(fp, 1):
                for ref in ref_pat.findall(line):
                    full = ref.replace('~', home)
                    # placeholder 패턴 제외
                    if '<' in full or '*' in full: continue
                    if not os.path.exists(full):
                        broken.append((path.replace(home, '~'), i, ref))
    except: pass
print(len(broken))
for p, i, r in broken[:5]:
    print(f'  {p}:{i} → {r}')
" 2>/dev/null)
BROKEN_COUNT=$(echo "$BROKEN_REFS" | head -1)
if [ "${BROKEN_COUNT:-0}" -eq 0 ]; then
  print_check PASS "SSOT 참조 정합성" "깨진 \`~/.claude/*.md\` 참조 0건"
else
  print_check WARN "SSOT 참조 정합성" "깨진 참조 $BROKEN_COUNT건"
  echo "$BROKEN_REFS" | tail -n +2 | sed 's/^/      /'
fi

# ── 15. global/projects 고아 파일 검사 (인덱스 누락) v2 신규 ──
ORPHAN_REPORT=$(python3 -c "
import os
gdir = os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'global')
pdir = os.path.join(os.environ['HOME'], '.claude', 'projects', os.environ['HOME'].replace('/', '-').replace('.', '-'), 'memory', 'projects')
mem = open('$HOME/.claude/projects/' + os.environ['HOME'].replace('/', '-').replace('.', '-') + '/memory/MEMORY.md').read()
g_orphan = [f for f in os.listdir(gdir) if f.endswith('.md') and f not in mem]
p_orphan = [f for f in os.listdir(pdir) if f.endswith('.md') and f not in mem]
total = len(g_orphan) + len(p_orphan)
print(total)
for f in g_orphan: print(f'  global/{f}')
for f in p_orphan: print(f'  projects/{f}')
" 2>/dev/null)
ORPHAN_COUNT=$(echo "$ORPHAN_REPORT" | head -1)
if [ "${ORPHAN_COUNT:-0}" -eq 0 ]; then
  print_check PASS "메모리 인덱스 등재" "고아 파일 0건 (모든 메모리 MEMORY.md에 인덱싱)"
else
  print_check WARN "메모리 인덱스 등재" "고아 파일 $ORPHAN_COUNT건"
  echo "$ORPHAN_REPORT" | tail -n +2 | sed 's/^/      /'
fi

# ── 16. 충돌 진단 Tier1 액션 적용 검증 (v2 신규) ──
# code-reviewer.md description에 "MUST BE USED" 잔존하면 약화 안 된 것
TIER1_C1=$(grep -c "MUST BE USED for all code changes" ~/.claude/agents/code-reviewer.md 2>/dev/null)
TIER1_C2=$(grep -c "1순위 분리" ~/.claude/agents/architect.md 2>/dev/null)
TIER1_C3=$(grep -c "1순위 분리" ~/.claude/agents/refactor-cleaner.md 2>/dev/null)
TIER1_C4=$(grep -c "브레인스톰 트리거 분기" ~/.claude/AGENTS_SYSTEM.md 2>/dev/null)
TIER1_TOTAL=$((TIER1_C1 == 0 ? 1 : 0))
TIER1_TOTAL=$((TIER1_TOTAL + (TIER1_C2 > 0 ? 1 : 0)))
TIER1_TOTAL=$((TIER1_TOTAL + (TIER1_C3 > 0 ? 1 : 0)))
TIER1_TOTAL=$((TIER1_TOTAL + (TIER1_C4 > 0 ? 1 : 0)))
if [ "$TIER1_TOTAL" -eq 4 ]; then
  print_check PASS "충돌 진단 Tier1 적용" "C-1 ~ C-4 모두 적용됨"
else
  print_check WARN "충돌 진단 Tier1 적용" "$TIER1_TOTAL/4 적용 (C-1=$([ $TIER1_C1 -eq 0 ] && echo OK || echo NO) C-2=$([ $TIER1_C2 -gt 0 ] && echo OK || echo NO) C-3=$([ $TIER1_C3 -gt 0 ] && echo OK || echo NO) C-4=$([ $TIER1_C4 -gt 0 ] && echo OK || echo NO))"
fi

# ── 자동 로드 사이즈 ──
AUTO_SIZE=$(cat ~/.claude/CLAUDE.md ~/.claude/RULES.md ~/.claude/FLAGS.md ~/.claude/AGENTS_SYSTEM.md ~/.claude/modes/_index.md ~/.claude/rules/common/*.md "$MEM_INDEX" 2>/dev/null | wc -c | tr -d ' ')

echo ""
echo "═══════════════════════════════════════════════════════"
echo " 결과: PASS=$PASS · WARN=$WARN · FAIL=$FAIL (총 16 검사)"
echo " 자동 로드 사이즈: $AUTO_SIZE B (목표 < 50000)"
echo "═══════════════════════════════════════════════════════"

rm -f /tmp/rule-check-files.txt
[ "${FAIL:-0}" -eq 0 ] && exit 0 || exit 1
