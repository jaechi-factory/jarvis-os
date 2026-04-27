---
description: 도구 호출 trace + Echo 검증. /trace [today|session|verify|N] — audit log를 읽어 누가 호출됐는지 한 화면에 보여줌. 5블록 Echo가 거짓이 아닌지 확인용.
---

# /trace — 도구 호출 트레이스 & Echo 검증

L1이 5블록 보고에 "code-reviewer 호출했음"이라고 적었는데, 실제로 audit log에 그 호출이 없으면 → **Echo가 거짓**.

`/trace`는 그걸 자동 검증하는 도구야.

## 사용법

```
/trace                # 오늘 전체 요약 (도구별 카운트 + 에이전트/스킬 호출 리스트)
/trace today          # 동일 (alias)
/trace dashboard      # ASCII 시각 대시보드 (도구 분포 + 시간대 + 에이전트 톱 + L2→L3 위임률)
/trace l2-check       # L2 디렉터 호출 후 L3 위임 자동 검증 (우회 의심 경고)
/trace session        # 현재 세션만 필터 (session_id 매칭)
/trace recent N       # 최근 N개 호출 시간순
/trace agents         # 오늘 호출된 에이전트만
/trace verify         # 마지막 응답의 5블록 Echo와 audit log 매칭 검증
/trace files          # 오늘 Edit/Write/MultiEdit으로 만진 파일 리스트
```

## 동작

1. `~/.claude/audit/$(date +%Y-%m-%d).jsonl` 읽기
2. 인자에 따라 필터/집계
3. 출력 (요약 + 디테일)

## 구현 (Claude가 실행)

이 명령이 호출되면 Claude는 아래 스크립트를 Bash 도구로 실행:

### `today` / 인자 없음

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
if [ ! -f "$log" ]; then echo "오늘 audit log 없음 (아직 도구 호출 0건)"; exit 0; fi

total=$(wc -l < "$log" | tr -d ' ')
echo "━━━ Audit Trace · $(date +%Y-%m-%d) ━━━"
echo "총 호출: $total건"
echo ""
echo "[도구별 카운트]"
python3 -c "
import json, collections
c = collections.Counter()
with open('$log') as f:
    for line in f:
        try: c[json.loads(line).get('tool','?')] += 1
        except: pass
for tool, n in c.most_common():
    print(f'  {tool:30s} {n:4d}')
"

echo ""
echo "[에이전트 호출 리스트]"
python3 -c "
import json
with open('$log') as f:
    for line in f:
        try:
            r = json.loads(line)
            if r.get('tool') in ('Agent','Task'):
                print(f\"  {r['ts'][11:19]} · {r.get('agent','?'):30s} · {r.get('desc','')[:60]}\")
        except: pass
"

echo ""
echo "[스킬 호출 리스트]"
python3 -c "
import json
with open('$log') as f:
    for line in f:
        try:
            r = json.loads(line)
            if r.get('tool') == 'Skill':
                print(f\"  {r['ts'][11:19]} · {r.get('skill','?'):40s}\")
        except: pass
"
```

### `dashboard` (ASCII 시각 대시보드 · 2026-04-26)

도구 분포·시간대별 호출·에이전트 톱·L2→L3 위임률을 한 화면에 시각화. `today`보다 분포 한눈에 파악 가능.

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
if [ ! -f "$log" ]; then echo "오늘 audit log 없음"; exit 0; fi

python3 <<'PY'
import json, collections
from datetime import datetime, timedelta

log_path = f"$log"
tool_counter = collections.Counter()
hour_counter = collections.Counter()
agent_counter = collections.Counter()
skill_counter = collections.Counter()
file_counter = collections.Counter()
all_agent_events = []
total = 0

with open(log_path) as f:
    for line in f:
        try:
            r = json.loads(line)
            total += 1
            tool = r.get('tool', '?')
            tool_counter[tool] += 1
            ts = r.get('ts', '')
            if len(ts) >= 13:
                hour_counter[ts[11:13]] += 1
            if tool in ('Agent', 'Task'):
                agent_counter[r.get('agent', '?')] += 1
                all_agent_events.append((datetime.fromisoformat(ts.replace('Z','')), r.get('agent','?')))
            elif tool == 'Skill':
                skill_counter[r.get('skill', '?')] += 1
            elif tool in ('Edit', 'Write', 'MultiEdit'):
                p = r.get('path', '')
                if p:
                    file_counter[p] += 1
        except: pass

def bar(n, peak, width=30):
    if peak == 0: return ''
    filled = int((n / peak) * width)
    return '█' * filled + '░' * (width - filled)

today = datetime.now().strftime('%Y-%m-%d %H:%M')
print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print(f" 📊 Trace Dashboard · {today} · 총 {total}건")
print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

print("\n[ 도구별 분포 ]")
peak = max(tool_counter.values()) if tool_counter else 0
for tool, n in tool_counter.most_common(10):
    pct = (n / total * 100) if total else 0
    print(f"  {tool:18s} {bar(n, peak):30s} {n:4d} ({pct:4.1f}%)")

print("\n[ 시간대별 호출 ]")
if hour_counter:
    peak_h = max(hour_counter.values())
    for h in sorted(hour_counter.keys()):
        n = hour_counter[h]
        print(f"  {h}:00  {bar(n, peak_h, 40):40s} {n:4d}")

if agent_counter:
    print("\n[ 에이전트 톱 ]")
    peak_a = max(agent_counter.values())
    for agent, n in agent_counter.most_common(8):
        print(f"  {agent:30s} {bar(n, peak_a, 20):20s} {n:3d}")

if skill_counter:
    print("\n[ 스킬 톱 ]")
    peak_s = max(skill_counter.values())
    for skill, n in skill_counter.most_common(8):
        print(f"  {skill:40s} {bar(n, peak_s, 15):15s} {n:3d}")

if file_counter:
    print(f"\n[ 만진 파일 톱 5 ] (총 {len(file_counter)}개 파일)")
    for p, n in sorted(file_counter.items(), key=lambda x: -x[1])[:5]:
        short = p if len(p) <= 60 else '...' + p[-57:]
        print(f"  ({n}회) {short}")

# L2 → L3 위임률 한 줄
L2_DIRECTORS = {'product-director','design-director','engineering-director','qa-director','growth-director','pm-director'}
l2_calls = [(t, a) for t, a in all_agent_events if a in L2_DIRECTORS]
if l2_calls:
    delegated = sum(1 for ts, a in l2_calls if any(ts < t2 <= ts + timedelta(minutes=5) and a2 not in L2_DIRECTORS for t2, a2 in all_agent_events))
    rate = delegated / len(l2_calls) * 100
    icon = "✅" if rate >= 80 else ("🟡" if rate >= 50 else "🔴")
    print(f"\n[ L2 → L3 위임률 ] {icon} {delegated}/{len(l2_calls)} ({rate:.0f}%)  · 상세: /trace l2-check")

print(f"\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
PY
```

### `l2-check` (L2→L3 위임 자동 검증 · 2026-04-26)

L2 디렉터 6명(`product/design/engineering/qa/growth/pm-director`) 호출 후 5분 안에 L3 Agent 호출이 0건이면 → **L2 우회 의심 경고**.

`AGENTS_SYSTEM.md` 섹션 6 "L3 위임 강제" 룰의 자동 검증 도구.

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
if [ ! -f "$log" ]; then echo "오늘 audit log 없음"; exit 0; fi

python3 <<'PY'
import json
from datetime import datetime, timedelta

L2_DIRECTORS = {
    'product-director', 'design-director', 'engineering-director',
    'qa-director', 'growth-director', 'pm-director'
}

events = []
with open(f"$log") as f:
    for line in f:
        try:
            r = json.loads(line)
            if r.get('tool') in ('Agent', 'Task'):
                ts = datetime.fromisoformat(r['ts'].replace('Z',''))
                events.append((ts, r.get('agent','?'), r.get('desc','')[:80]))
        except: pass

l2_calls = [(ts, a, d) for ts, a, d in events if a in L2_DIRECTORS]
print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print(f" 🔍 L2 → L3 위임 검증 · 오늘 L2 호출 {len(l2_calls)}건")
print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

if not l2_calls:
    print("\n오늘 L2 디렉터 호출 0건. 검증할 항목 없음.")
else:
    bypass_count = 0
    delegated_count = 0
    for ts, agent, desc in l2_calls:
        window_end = ts + timedelta(minutes=5)
        l3_calls = [(t, a) for t, a, _ in events if ts < t <= window_end and a not in L2_DIRECTORS]
        if l3_calls:
            delegated_count += 1
            print(f"\n  ✅ {ts.strftime('%H:%M:%S')} {agent}")
            print(f"     desc: {desc}")
            print(f"     L3 호출 {len(l3_calls)}건 → {', '.join(set(a for _,a in l3_calls))}")
        else:
            bypass_count += 1
            print(f"\n  🔴 {ts.strftime('%H:%M:%S')} {agent}  ⚠️ L3 호출 0건 (우회 의심)")
            print(f"     desc: {desc}")

    total = len(l2_calls)
    rate = (delegated_count / total * 100) if total else 0
    print(f"\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    print(f" 위임률: {delegated_count}/{total} ({rate:.0f}%)  ·  우회 의심: {bypass_count}건")
    if bypass_count > 0:
        print(f" 🔴 룰 위반 의심. 각 우회 호출에서 L2가 출력에 'L3 호출 생략 · 사유'를")
        print(f"    명시했는지 5블록 리포트 확인 필요. 명시 없으면 거짓 보고.")
    print(f"━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
PY
```

**한계**: audit log만으로는 "L3 호출 생략 사유 명시 여부"는 못 잡음. 사용자가 의심날 때 직접 그 시점 5블록 리포트 봐야 함. 하지만 우회 의심 신호 자체는 자동 검출 가능.

### `session` (현재 세션만)

session_id를 알 수 없으니 Claude는 가장 최근 호출의 session 값을 기준으로 필터:

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
session=$(tail -1 "$log" | python3 -c "import sys,json; print(json.loads(sys.stdin.read()).get('session',''))")
echo "현재 세션: $session"
echo ""
grep "\"session\": \"$session\"" "$log" | python3 -c "
import sys, json
for line in sys.stdin:
    try:
        r = json.loads(line)
        ts = r['ts'][11:19]
        tool = r.get('tool','?')
        extra = r.get('agent') or r.get('skill') or r.get('cmd','')[:50] or r.get('path','')
        print(f'  {ts} {tool:8s} {extra}')
    except: pass
"
```

### `verify` (Echo ↔ audit 매칭)

직전 응답에서 라우팅 Echo 줄(🧭 L1 → ...)에 등장한 에이전트들이 audit log에 실제로 있는지 검증:

1. Claude는 마지막 응답을 보고 Echo에 적힌 에이전트/디렉터 이름 추출
2. 같은 세션 audit log에서 해당 Agent 호출 검색
3. 빠진 항목이 있으면 ⚠️ 리포트:
   ```
   Echo claim: code-reviewer, ui-designer
   Audit log:  [code-reviewer ✓], [ui-designer ✗ NOT FOUND]
   결론: Echo 거짓 - ui-designer는 호출 안 됐음
   ```

### `recent N`

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
tail -${N:-20} "$log" | python3 -c "
import sys, json
for line in sys.stdin:
    try:
        r = json.loads(line)
        ts = r['ts'][11:19]
        tool = r.get('tool','?')
        extra = r.get('agent') or r.get('skill') or r.get('cmd','')[:50] or r.get('path','') or r.get('mcp','')
        print(f'  {ts} {tool:10s} {extra}')
    except: pass
"
```

### `files`

```bash
log=~/.claude/audit/$(date +%Y-%m-%d).jsonl
python3 -c "
import json
seen = {}
with open('$log') as f:
    for line in f:
        try:
            r = json.loads(line)
            if r.get('tool') in ('Edit','Write','MultiEdit'):
                p = r.get('path','')
                if p:
                    seen[p] = seen.get(p, 0) + 1
        except: pass
for p, n in sorted(seen.items(), key=lambda x: -x[1]):
    print(f'  ({n}회) {p}')
"
```

## 결과 해석

- **Echo와 audit log 100% 매칭** = L1이 5블록에 적은 게 진실
- **Echo는 있는데 audit log에 없음** = 거짓 보고. 즉시 {{USER_NAME}}한테 사실 정정 + 메모리 `feedback_agent_invocation_real.md` 위반
- **Audit log에는 있는데 Echo에 없음** = 보고 누락 (덜 심각하지만 가시성 룰 위반)

## 주의

- audit log는 **PostToolUse hook이 실행된 도구**만 잡음 — 모델 내부 사고/계획은 못 잡음 (그건 transcript에 있음)
- `/trace`는 진단 도구지 강제력은 없음. Claude가 거짓 Echo 작성하는 걸 막진 못하지만, {{USER_NAME}}이 의심날 때 즉시 검증 가능
- 강제력은 별도로 Stop hook에서 자동 verify를 박는 방식으로 추후 확장 가능 (지금은 {{USER_NAME}} 트리거 방식)
