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
- **Echo는 있는데 audit log에 없음** = 거짓 보고. 즉시 ben한테 사실 정정 + 메모리 `feedback_agent_invocation_real.md` 위반
- **Audit log에는 있는데 Echo에 없음** = 보고 누락 (덜 심각하지만 가시성 룰 위반)

## 주의

- audit log는 **PostToolUse hook이 실행된 도구**만 잡음 — 모델 내부 사고/계획은 못 잡음 (그건 transcript에 있음)
- `/trace`는 진단 도구지 강제력은 없음. Claude가 거짓 Echo 작성하는 걸 막진 못하지만, ben이 의심날 때 즉시 검증 가능
- 강제력은 별도로 Stop hook에서 자동 verify를 박는 방식으로 추후 확장 가능 (지금은 ben 트리거 방식)
