#!/usr/bin/env bash
# Stop hook: prints a compact "this session's tool call summary" footer
# automatically after every response. {{USER_NAME}} doesn't need to remember /trace.
#
# Source of truth: ~/.claude/audit/YYYY-MM-DD.jsonl (written by audit-log.sh)
# Filter: same session_id only (one footer = one session's accumulated calls)

input=$(cat)
session=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('session_id',''))" 2>/dev/null)
audit_log="$HOME/.claude/audit/$(date +%Y-%m-%d).jsonl"

if [ -z "$session" ] || [ ! -f "$audit_log" ]; then
  exit 0
fi

export CLAUDE_AUDIT_SESSION="$session"
export CLAUDE_AUDIT_LOG="$audit_log"

python3 <<'PY' 2>/dev/null
import os, json, collections

session = os.environ.get('CLAUDE_AUDIT_SESSION', '')
log = os.environ.get('CLAUDE_AUDIT_LOG', '')

rows = []
try:
    with open(log) as f:
        for line in f:
            try:
                r = json.loads(line)
                if r.get('session') == session:
                    rows.append(r)
            except Exception:
                continue
except Exception:
    raise SystemExit(0)

if not rows:
    raise SystemExit(0)

# Track marker file for "this turn" diff (lines added since last Stop)
marker = os.path.expanduser('~/.claude/audit/.last-stop-' + session)
prev_count = 0
try:
    with open(marker) as f:
        prev_count = int(f.read().strip() or '0')
except Exception:
    prev_count = 0

current_count = len(rows)
turn_rows = rows[prev_count:] if current_count > prev_count else []

# Update marker for next turn
try:
    with open(marker, 'w') as f:
        f.write(str(current_count))
except Exception:
    pass

c_total = collections.Counter(r.get('tool', '?') for r in rows)
c_turn = collections.Counter(r.get('tool', '?') for r in turn_rows)

def fmt_counts(counter):
    parts = []
    order = ('Agent', 'Task', 'Skill', 'Bash', 'Edit', 'Write', 'MultiEdit',
             'Read', 'TodoWrite', 'WebFetch', 'WebSearch')
    for tool in order:
        if tool in counter:
            parts.append(f"{tool}×{counter[tool]}")
    mcp_total = sum(v for k, v in counter.items() if k.startswith('mcp__'))
    if mcp_total:
        parts.append(f"MCP×{mcp_total}")
    other = sum(v for k, v in counter.items()
                if k not in order and not k.startswith('mcp__'))
    if other:
        parts.append(f"기타×{other}")
    return ' '.join(parts) if parts else '(none)'

# This-turn detail
turn_agents = [r.get('agent') for r in turn_rows
               if r.get('tool') in ('Agent', 'Task') and r.get('agent')]
turn_skills = [r.get('skill') for r in turn_rows
               if r.get('tool') == 'Skill' and r.get('skill')]
turn_files = sorted(set(r.get('path', '') for r in turn_rows
                        if r.get('tool') in ('Edit', 'Write', 'MultiEdit') and r.get('path')))
turn_codex = sum(1 for r in turn_rows if r.get('tool') == 'mcp__codex-cli__codex')

# Session-wide cumulative
total_agents = [r.get('agent') for r in rows
                if r.get('tool') in ('Agent', 'Task') and r.get('agent')]
total_skills = [r.get('skill') for r in rows
                if r.get('tool') == 'Skill' and r.get('skill')]
total_files = sorted(set(r.get('path', '') for r in rows
                         if r.get('tool') in ('Edit', 'Write', 'MultiEdit') and r.get('path')))
total_codex = sum(1 for r in rows if r.get('tool') == 'mcp__codex-cli__codex')

print()
print('━━━ 도구 호출 트레이스 ━━━')
print(f"이번 턴: {fmt_counts(c_turn)}" if turn_rows else "이번 턴: (도구 호출 없음)")

if turn_agents:
    head = ', '.join(turn_agents[:6])
    rest = f' (외 {len(turn_agents)-6})' if len(turn_agents) > 6 else ''
    print(f"  ↳ Agents: {head}{rest}")
if turn_skills:
    head = ', '.join(turn_skills[:6])
    rest = f' (외 {len(turn_skills)-6})' if len(turn_skills) > 6 else ''
    print(f"  ↳ Skills: {head}{rest}")
if turn_codex:
    print(f"  ↳ Codex: {turn_codex}회")
if turn_files:
    print(f"  ↳ 만진 파일 {len(turn_files)}개:")
    for p in turn_files[:5]:
        # Shorten home path for readability
        short = p.replace(os.path.expanduser('~'), '~')
        print(f"     {short}")
    if len(turn_files) > 5:
        print(f"     (외 {len(turn_files)-5}개)")

print(f"세션 누적: {fmt_counts(c_total)}")
extras = []
if total_agents: extras.append(f"Agent {len(total_agents)}회({len(set(total_agents))}종)")
if total_skills: extras.append(f"Skill {len(total_skills)}회")
if total_codex: extras.append(f"Codex {total_codex}회")
if total_files: extras.append(f"파일 {len(total_files)}개")
if extras:
    print('  ' + ' · '.join(extras))

print('━━━━━━━━━━━━━━━━━━━━━━━━━━')
PY

# ── C-8: 룰 파일 변경 감지 → /check-rules 자동 트리거 ──
RULE_MARKER="$HOME/.claude/audit/.rule-changed-$session"
if [ -f "$RULE_MARKER" ]; then
  CHANGED_COUNT=$(wc -l < "$RULE_MARKER" | tr -d ' ')
  CHANGED_FILES=$(sort -u "$RULE_MARKER" | head -5)
  echo ""
  echo "━━━ 🔍 룰/메모리 파일 변경 감지 ━━━"
  echo "  변경 횟수: $CHANGED_COUNT (이번 턴)"
  echo "$CHANGED_FILES" | sed "s|$HOME|~|" | sed 's/^/  · /'
  echo ""
  echo "━━━ 자동 /check-rules 실행 ━━━"
  if [ -x "$HOME/.claude/hooks/check-rules.sh" ]; then
    bash "$HOME/.claude/hooks/check-rules.sh" 2>&1 | tail -22
  else
    echo "  (check-rules.sh 누락 — 수동 검사 필요)"
  fi
  rm -f "$RULE_MARKER"
fi

# ── C-9: 메모리 파일 신규/덮어쓰기 감지 → 인덱싱 검사 ──
MEM_MARKER="$HOME/.claude/audit/.memory-new-$session"
if [ -f "$MEM_MARKER" ]; then
  python3 <<PY 2>/dev/null
import os
home = os.path.expanduser('~')
marker = '$MEM_MARKER'
mem_index = f'{home}/.claude/projects/{home.replace(chr(47), chr(45))}/memory/MEMORY.md'
try:
    with open(marker) as f:
        paths = [p.strip() for p in f.readlines() if p.strip()]
    with open(mem_index) as f:
        index_text = f.read()
    unindexed = []
    for p in paths:
        fname = os.path.basename(p)
        # MEMORY.md 자체는 인덱스 파일이라 검사 제외
        if fname == 'MEMORY.md':
            continue
        if fname not in index_text:
            unindexed.append(p)
    if unindexed:
        print('')
        print('━━━ ⚠️  메모리 인덱스 미등재 감지 ━━━')
        print(f'  이번 턴에 만진 메모리 파일 중 {len(unindexed)}개가 MEMORY.md에 없음:')
        for p in unindexed[:5]:
            short = p.replace(home, '~')
            print(f'  · {short}')
        print('  → MEMORY.md에 1줄 인덱스 추가 권장 (\"고아 파일\" 재발 방지)')
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━')
except Exception:
    pass
PY
  rm -f "$MEM_MARKER"
fi

exit 0
