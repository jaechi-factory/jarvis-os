#!/usr/bin/env bash
# Stop hook — audit-summary.sh 앞에 실행
# 디렉터 트리거 키워드 매칭 + Agent 호출 0건 → 위반 기록 + 다음 턴 회복 알림 예약
# 단, 자비스가 첫 줄에 "🧭 L1 (direct" 라벨 명시한 경우 면제
#
# SSOT: AGENTS_SYSTEM.md 섹션 4 트리거 표

set -uo pipefail
state_dir="$HOME/.claude/state"
mkdir -p "$state_dir"

# Stop hook input에서 transcript_path 추출 (direct 라벨 검사용)
input=$(cat 2>/dev/null || echo "{}")
transcript_path=$(echo "$input" | python3 -c "import sys,json; print(json.load(sys.stdin).get('transcript_path',''))" 2>/dev/null || echo "")

prompt_file="${state_dir}/last-prompt.txt"
[ ! -f "$prompt_file" ] && exit 0

prompt=$(cat "$prompt_file" 2>/dev/null || echo "")
[ -z "$prompt" ] && { rm -f "$prompt_file"; exit 0; }

# direct 라벨 면제 검사 — 자비스가 마지막 응답 첫 부분에 "🧭 L1 (direct" 명시했으면 면제
direct_label=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    # transcript jsonl에서 마지막 assistant 메시지 추출
    last_assistant=$(python3 -c "
import sys, json
try:
    msgs = []
    with open('$transcript_path') as f:
        for line in f:
            try:
                m = json.loads(line)
                # 다양한 형식 대응 (role 필드 또는 type 필드)
                role = m.get('role') or m.get('type') or m.get('message',{}).get('role','')
                if role == 'assistant':
                    # content가 string 또는 array
                    content = m.get('content') or m.get('message',{}).get('content','')
                    if isinstance(content, list):
                        text = ' '.join(b.get('text','') for b in content if isinstance(b,dict))
                    else:
                        text = str(content)
                    msgs.append(text[:2000])
            except: pass
    if msgs:
        # 마지막 assistant 메시지의 첫 500자
        print(msgs[-1][:500])
except: pass
" 2>/dev/null || echo "")

    # 첫 500자 안에 direct 패턴 있으면 면제
    if echo "$last_assistant" | grep -qE "🧭 L1 \(direct"; then
        direct_label=1
    fi
fi

if [ "$direct_label" = "1" ]; then
    # direct 라벨 명시 — 면제. 정리 후 silent exit
    rm -f "$prompt_file"
    exit 0
fi

# AGENTS_SYSTEM.md 섹션 4 디렉터 트리거 키워드 (한국어/영어)
# 단어 경계 의존 X — 한국어는 공백/조사 변동이 커서 부분 매칭 허용
DIRECTOR_KEYWORDS='제품|방향성|시장|경쟁사|수익화|비즈니스|타겟|PMF|monetize|디자인|UI|UX|화면|플로우|레이아웃|컴포넌트|비주얼|문구|카피|감도|구현|코드|아키텍처|버그|에러|빌드|성능|리팩토링|스키마|타입|refactor|배포 전|QA|테스트|보안|리뷰|E2E|검증|취약점|security|런칭|홍보|마케팅|SEO|바이럴|획득|유지|리텐션|그로스|launch|growth|복잡한|여러 단계|여러 도메인|계획|로드맵|분해|순서|자동 개선|루프|orchestrate'

if ! echo "$prompt" | grep -qiE "$DIRECTOR_KEYWORDS"; then
    rm -f "$prompt_file"
    exit 0
fi

matched=$(echo "$prompt" | grep -oiE "$DIRECTOR_KEYWORDS" | sort -u | head -3 | tr '\n' ',' | sed 's/,$//')

# 이번 턴 jsonl에서 Agent 카운트
date_today=$(date +%Y-%m-%d)
log_file="$HOME/.claude/audit/${date_today}.jsonl"
turn_start=$(cat "${state_dir}/turn-start-line.txt" 2>/dev/null || echo 0)

agent_count=0
if [ -f "$log_file" ]; then
    total_lines=$(wc -l < "$log_file" | tr -d ' ')
    if [ "$total_lines" -gt "$turn_start" ]; then
        # grep -c 는 매칭 0건이면 exit 1 — || true 로 흡수, stdout="0"만 남김
        agent_count=$(tail -n +$((turn_start + 1)) "$log_file" | grep -c '"tool":"Agent"' 2>/dev/null || true)
        agent_count=${agent_count:-0}
    fi
fi

# Agent 0건이면 위반 (direct 라벨 자가 면제는 hook이 응답 텍스트 못 봐 미구현)
violation_file="${state_dir}/last-violation.txt"
if [ "$agent_count" = "0" ]; then
    cat > "$violation_file" <<EOF
[직전 턴 디렉터 누락 위반]
- 사용자 메시지 키워드: ${matched}
- Agent(L2 디렉터) 호출: 0건
- 룰 위반: AGENTS_SYSTEM.md 섹션 4 "트리거 매칭 시 디렉터 호출 의무"

[이번 턴 자비스 강제 회복 액션 — 응답 시작 전 판단]
1. 매칭 키워드에 해당하는 L2 디렉터 매칭 → 5블록 라우팅 Echo 출력 후 정상 처리
2. 또는 명시 사유 표기: 첫 줄에 "🧭 L1 (direct · <왜 직접 처리했는지>)"
   — 단, 메모리 조회/메타 질문/한 줄 답변만 direct 허용 (CLAUDE.md 섹션 4 예외)
3. 회복 호출 후 응답 끝에 "[자가 회복 완료]" 문구 출력
EOF

    # 화면 알림
    echo ""
    echo "━━━ ⚠️  디렉터 누락 위반 감지 ━━━"
    echo "키워드: ${matched} | Agent 호출: 0건"
    echo "다음 턴에 자비스가 자동 회복합니다."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━"

    # audit log
    ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    safe_matched=$(echo "$matched" | sed 's/\\/\\\\/g; s/"/\\"/g')
    echo "{\"ts\":\"$ts\",\"event\":\"director_violation_detected\",\"keywords\":\"$safe_matched\",\"agent_count\":0}" >> "$log_file"
fi

rm -f "$prompt_file"
exit 0
