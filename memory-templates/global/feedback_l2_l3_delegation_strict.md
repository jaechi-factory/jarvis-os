---
name: L2 → L3 위임 강제 룰 v1.0
description: L2 디렉터(6명)는 도메인 작업 시 반드시 L3 실무자를 Agent 툴로 호출. 우회 시 명시 의무 + audit log 자동 검출.
type: feedback
---

# L2 → L3 위임 강제 룰 v1.0 (2026-04-26)

## 룰

L2 디렉터(product/design/engineering/qa/growth/pm) 6명은 도메인 작업이 들어오면 **반드시 자기 산하 L3 실무자를 Agent 툴로 호출**해야 한다. 자기가 직접 Read·Bash로 처리하고 끝내면 룰 위반.

**Why**: audit log 검증 결과 L2 디렉터 호출 후 L3 위임 0건이 일관되게 발견됨. 특히 사용자가 "GAN 시리즈 굴려라" 명시 요청한 pm-director가 GAN 호출 안 하고 자체 Read·Bash로 우회. 사용자한테 우회 사실 안 알림 → 거짓 보고 + 신뢰 사슬 파괴. 이게 1건 우연이 아니라 모든 L2가 일관되게 보이는 구조적 패턴이라 룰 강화로 박음.

**How to apply**:
1. L2 디렉터 정의 6개에 "🔴 L3 위임 강제 룰" 섹션 박음 (2026-04-26 완료)
2. `core/AGENTS_SYSTEM.md` 섹션 6에 "L2 → L3 위임 강제" 룰 + 우회 자동 검출 추가
3. 우회 허용 조건 (셋 중 하나만):
   - 사용자 명시 ("직접 처리해")
   - 단순 조회·확인 (Read 1~2건 메타 질문)
   - 호출 가능한 L3 부재
4. 우회 시 명시 의무: 출력 포맷에 `L3 호출 생략 · 사유: <한 줄>` + 직접 수행한 작업 명시
5. audit log 자동 검증: `/trace l2-check` 명령 — L2 호출 후 5분 안에 Agent 호출 0건이면 우회 의심 경고

## 영향 범위

- 6개 디렉터 정의 (`core/agents/{product,design,engineering,qa,growth,pm}-director.md`) — 강화됨 2026-04-26
- `core/AGENTS_SYSTEM.md` 섹션 6 — 강화됨 2026-04-26
- `core/commands/trace.md` — `dashboard` + `l2-check` 서브커맨드 추가됨 2026-04-26

## 검증 방법

평소 `/trace dashboard` 한 번 치면 도구 분포와 L2→L3 위임률 즉시 확인. 의심날 때 `/trace l2-check`로 디렉터별 우회 여부 검증.

위임률 임계값:
- ✅ 80%+ : 정상
- 🟡 50~79% : 주의
- 🔴 <50% : 룰 위반 의심, 5블록 리포트에 "L3 호출 생략 · 사유" 명시 여부 확인 필요

## 관련 문서

- `core/AGENTS_SYSTEM.md` 섹션 6 — SSOT
- `feedback_agent_invocation_real.md` — 에이전트 실호출 의무 (Echo ≠ 실행). 이 룰은 그 확장
