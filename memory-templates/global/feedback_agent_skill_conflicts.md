---
name: 에이전트·스킬 충돌·중복 진단 v1.0
description: 2026-04-25 시스템 전수 스캔 결과. 같은 의도 영역에 후보 N개가 매칭되는 케이스, 트리거 충돌, 모호 라우팅 식별 + 1순위 결정 + 단계별 정리 액션
type: feedback
originSessionId: d7fff20e-9262-4005-9636-8b3d6923e2af
---
# 에이전트·스킬 충돌·중복 진단 v1.0

**스캔 일자**: 2026-04-25
**스캔 범위**: agents 38개 + plugins 26개(218 skills) + commands 53개 + hooks 5개 + modes 7개

---

## 🔴 Tier 1 — 즉시 해소 필요 (실제 라우팅 충돌, ben이 매번 헷갈림)

### C-1. "코드 리뷰" 영역 — 4중 매칭

| 후보 | 위치 | description의 우선순위 주장 |
|---|---|---|
| `code-reviewer` | agents/ | "MUST BE USED for all code changes" |
| `typescript-reviewer` | agents/ | "MUST BE USED for TypeScript/JavaScript projects" |
| `silent-failure-hunter` | agents/ | swallowed errors 전문 |
| `compound-engineering:ce-review` | skill | tiered persona agents |

**문제**: TS 파일이면 code-reviewer vs typescript-reviewer 둘 다 "MUST BE USED" 주장 → 자동 트리거 충돌
**1순위 결정**:
1. TS/JS 변경 → `typescript-reviewer` (전문성 좁음)
2. 다언어/일반 → `code-reviewer`
3. 디버깅 컨텍스트 → `silent-failure-hunter`
4. 대규모 PR/배포 전 → `compound-engineering:ce-review` (다관점)
**액션**: `code-reviewer.md` description에서 "MUST BE USED" → "Default for non-TS code reviews" 로 약화

### C-2. "아키텍처" 영역 — 2중 모호

| 후보 | 위치 | 차이점 |
|---|---|---|
| `architect` | agents/ | 시스템 레벨 아키텍처 |
| `code-architect` | agents/ | 코드 레벨, 모듈/패키지 구조 |

**문제**: AGENTS_SYSTEM.md엔 둘 다 engineering-director 소속, 차이가 description으로만 구분 → ben 시점에서 모호
**1순위 결정**:
- "시스템 설계, 새 프로젝트 구조" → `architect`
- "기존 코드 리팩토링용 모듈 분할" → `code-architect`
**액션**: 두 에이전트의 명칭을 `system-architect` / `module-architect` 로 리네이밍 권장 (단, 에이전트 파일명 변경은 영향 큼 → 일단 description만 명확화)

### C-3. "리팩토링/단순화" — 3중 매칭

| 후보 | 위치 |
|---|---|
| `refactor-cleaner` | agents/ — dead code 제거, knip/depcheck 도구 사용 |
| `code-simplifier` | agents/ — 가독성/일관성 단순화 |
| `compound-engineering:review:code-simplicity-reviewer` | skill |

**1순위 결정**:
- dead code/duplicate 제거 → `refactor-cleaner`
- 복잡도 ↓ → `code-simplifier`
- PR 마지막 simplicity 패스 → `code-simplicity-reviewer`
**액션**: AGENTS_SYSTEM.md L3 표에 "구분 기준" 칼럼 추가

### C-4. "브레인스토밍" — 4중 매칭 (가장 심각)

| 후보 | 위치 | 트리거 |
|---|---|---|
| `--brainstorm` 모드 | modes/brainstorming.md | --bs 플래그 |
| `superpowers:brainstorming` | skill | "must use this before any creative work" |
| `compound-engineering:ce-brainstorm` | skill | 협업 다이얼로그 |
| `pm-product-discovery:brainstorm-ideas-new` | skill | PM/디자이너/엔지니어 3관점 |
| `pm-product-strategy:value-proposition` | skill (인접) | JTBD |

**문제**: ben이 "아이디어"라고 말하면 4개 동시 후보. superpowers는 "MUST USE" 주장 → 항상 발동돼야 함
**1순위 결정** (의도별):
- 모호한 요구사항 발굴 → `--brainstorm` 모드 (Socratic 다이얼로그)
- 신규 제품/기능 ideation → `pm-product-discovery:brainstorm-ideas-new` (PM/디자이너/엔지니어 3관점, 가장 구조적)
- 코드/기술 결정 ideation → `superpowers:brainstorming` (제일 강한 의무성, 코드 직전에)
- 협업 다이얼로그 → `compound-engineering:ce-brainstorm`
**액션**: AGENTS_SYSTEM.md 섹션 4에 "브레인스토밍 트리거 분기 표" 신설

### C-5. "리서치" — 5중 매칭

| 후보 | 트리거 |
|---|---|
| `--research` 모드 | --research 플래그 |
| `compound-engineering:research:*` (best-practices, framework-docs, repo-research, slack 등 9개) | description 자동 |
| `context7` MCP | 라이브러리 문서 |
| Tavily MCP | 웹 검색 |
| Exa MCP | 웹 검색 (rules/common 언급) |

**문제**: "리서치" 한 단어에 5개 후보 → 어느 거 쓸지 매번 판단 비용
**1순위 결정** (의도별):
- 라이브러리/프레임워크 공식 문서 → `context7` (절대 1순위, 공식 룰)
- 웹/시장 조사 → Tavily MCP (--research 모드 동반)
- 코드베이스 깊이 분석 → `compound-engineering:research:repo-research-analyst`
- 깃 히스토리 → `compound-engineering:research:git-history-analyzer`
- 외부 모범사례 → `compound-engineering:research:best-practices-researcher`
- Slack 맥락 → `compound-engineering:research:slack-researcher`
**액션**: `reference_official_tools_integration.md`에 의도별 라우팅 표 강화

### C-6. "사용성/UI 평가" — 4중 매칭

| 후보 | 위치 |
|---|---|
| `gui-critic` | agents/ — 한국어 SSOT 비주얼 감도 리뷰 |
| `frontend-design-audit:evaluate` | plugin |
| `prototyping-testing:heuristic-evaluation` | plugin |
| `design-systems:audit-system` | plugin |

**1순위 결정** (이미 디자인 라우팅 룰 v1.0 박혀있음 — `feedback_design_tool_routing.md`):
- 우리 프로젝트 화면 비주얼 감도 → `gui-critic` (한국어 SSOT)
- 프론트엔드 코드 사용성 평가 → `frontend-design-audit:evaluate`
- Nielsen 휴리스틱 평가 → `prototyping-testing:heuristic-evaluation`
- 디자인 시스템 일관성 → `design-systems:audit-system`
**액션**: 현재 룰이 이미 정의돼 있음. 변경 없음. 단, 이 진단 파일에 명시적으로 인용

### C-7. "경쟁사 분석" — 3중 매칭

| 후보 | 위치 |
|---|---|
| `market-researcher` | agents/ — 시장+경쟁사 통합 |
| `pm-market-research:competitor-analysis` | skill |
| `ux-strategy:competitive-analysis` | skill — UX 패턴 비교 |
| `pm-go-to-market:battlecard` | skill — 세일즈 카드 |

**1순위 결정** (이미 도구 우선순위 맵 v1.0 박혀있음 — `feedback_tool_priority_map.md`):
- 시장 규모+포지셔닝+경쟁사 통합 → `market-researcher`
- 기능 비교표/SWOT → `pm-market-research:competitor-analysis`
- UX 패턴 비교 → `ux-strategy:competitive-analysis`
- 세일즈/반박 카드 → `pm-go-to-market:battlecard`
**액션**: 변경 없음

### C-8. "PRD/기획서" — 3중 매칭

| 후보 | 위치 |
|---|---|
| `pm-execution:write-prd` | skill — 8섹션 템플릿 |
| `sc:design` | superclaude command |
| `sc:workflow` | superclaude command — PRD에서 워크플로우 생성 |
| `compound-engineering:ce-plan` | skill — 구조화된 다단계 계획 |

**1순위 결정**:
- 신규 기능 PRD → `pm-execution:write-prd` (가장 PM-네이티브)
- 다단계 구현 계획 → `compound-engineering:ce-plan`
- 시스템 디자인 문서 → `sc:design`
**액션**: AGENTS_SYSTEM.md PM Skills 자동 트리거 표는 이미 PRD → /write-prd 매핑 있음. 유지

---

## 🟡 Tier 2 — 관찰 영역 (2026-04-25 액션 결정)

### W-1. PM Skills 8 플러그인 분산 — **결정: 변경 없음**
- 65개 스킬이 8개 네임스페이스로 분산. 같은 키워드 다중 매칭
- **이미 처리됨**: AGENTS_REFERENCE 섹션 2에 핵심 11개 트리거 명시. 나머지 55개는 description 자동 로드
- **다음**: audit log 1주 누적 후 미사용 스킬 데이터 보고 정리 결정

### W-2. 디자이너 9 플러그인 분산 — **결정: 변경 없음**
- 73개 스킬. 영어 디자인 스킬 vs 한국어 SSOT(ux-writer/gui-critic)
- **이미 처리됨**: `feedback_design_tool_routing.md` v1.0 박혀있음 (혼합 모델 C)
- **다음**: audit log 1주 누적 후 데이터 보고 결정

### W-3. 트리거 누적 폭발 위험 — **✅ 해소됨**
- **룰 박음**: AGENTS_SYSTEM.md 섹션 4 "트리거 누적 폭발 방지 룰" (2026-04-25 W-3 액션)
- **자동 검증**: `/check-rules` 항목 12 (3+회 등장 키워드 자동 검출, 현재 0개)
- **현재 상태**: 트리거 키워드 누적 0건. 폭발 임박 신호 없음

### W-4. GAN 시리즈 활용 빈도 — **결정: 1주 데이터 후 판단**
- gan-planner / gan-generator / gan-evaluator + loop-operator
- 카탈로그 v1.4에서 활성 재배분됨. 실측 데이터 없음
- **다음**: audit log 1주 운영 → `/trace agents`로 호출 빈도 확인 → 0회면 비활성

### W-5. compound-engineering:review:* 28개 + document-review:* 7개 풀 — **결정: 1주 데이터 후 판단**
- AGENTS_SYSTEM/REFERENCE에 "qa-director 동원" 명시
- 실제 호출 빈도 미측정
- **다음**: audit log 1주 누적 후 미사용 풀 식별 → 활용 가이드 보강 또는 비활성

---

### 📊 Tier 2 종합 결정 (2026-04-25)

| ID | 영역 | 결정 |
|---|---|---|
| W-1 | PM 8 플러그인 | 변경 없음 (이미 11 트리거) |
| W-2 | 디자이너 9 플러그인 | 변경 없음 (라우팅 룰 박힘) |
| W-3 | 트리거 누적 위험 | ✅ 해소 (룰 + 자동 검증) |
| W-4 | GAN 활용 빈도 | 1주 데이터 후 |
| W-5 | CE review pool | 1주 데이터 후 |

**Action 사이클**: audit log 누적 1주 → `/trace agents` + `/trace recent N` → 호출 빈도 0인 도구 식별 → 카탈로그 미사용 라벨링 → ben 픽 받아 정리
**다음 측정 시점**: 2026-05-02 (1주 후)

---

## 🟢 Tier 3 — 관찰만 (낭비지만 비활성 시 위험)

### O-1. 거의 안 쓰는 commands/
- 53개 commands 중 핵심 사용 빈도: ce-plan, ce-work, ce-review, audit, claw, plan, init, status, sc, ux-write, ux-wash 정도
- 나머지 ~40개는 휴면 상태
- 비활성 시 mental load↓ but 슬래시 명령은 비활성 메커니즘 약함
- **액션**: audit log 1개월 호출 빈도로 정리

### O-2. SuperClaude /sc:* 30+ commands
- /sc:design, /sc:workflow, /sc:implement, /sc:troubleshoot 등
- ben이 명시적으로 부르는 일 거의 없음
- 자동 트리거 룰에도 빠져있음
- **액션**: 명시 호출만 허용. 자동 트리거 추가 안 함

---

## 🟦 신규 룰 — 충돌 해소 자동화

### R-1. "같은 의도 영역에 후보 2+개" 룰
- 이 진단 파일 1순위 따름
- 1순위 미정의 영역은 ben한테 선택지 제시 (3개 이하로)

### R-2. "MUST BE USED" 주장 충돌 시
- 더 좁은 전문성 우선 (typescript-reviewer > code-reviewer)
- 동급이면 호출 비용 ↓ 우선

### R-3. "트리거 누적 검사"
- 새 트리거 키워드 추가 시 기존 트리거와 충돌 검사 의무
- AGENTS_SYSTEM.md 섹션 4 표에 추가 시 PR 단위 진단 필수

---

## 다음 측정 포인트

audit log 1주일 운영 후:
1. 실제 호출 빈도 톱 30 vs 카탈로그 톱 30 일치율
2. "Echo만 하고 호출 안 한" 케이스 0건 검증
3. 미호출 도구 비율 (현재 카탈로그 v1.4 기준 61%) 재측정
4. 충돌 영역 중 ben이 "잘못 호출됐다" 신고 횟수

분기 재검증: 2026-07-25
