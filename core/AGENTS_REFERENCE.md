# Agent System — Reference

> **역할**: `AGENTS_SYSTEM.md`(자동 로드, 핵심 라우팅·5블록·운영 룰)의 **세부 부록**.
> **로드 시점**: 자동 로드 X. L1이 라우팅·플로우 결정 시점에 필요하면 `Read` 1회.
> **포함**: L3 Leader 32개 description / 호출 플로우 예시 / 다중 의견 충돌 처리 세부 / PM Skills 자동 트리거 매핑 / 공식 도구 트리거 / 리뷰어 풀
>
> **상위 SSOT**: `AGENTS_SYSTEM.md`. 본 파일은 그 부록.

---

## 1. L3 — Leader (직군 리더 · 핵심 23개 + 플러그인 번들 9개 = 32개)

> **v2.0 갱신 노트 (2026-04-25)**: 5단 조직도 적용 — L3 = Leader 32개(직군 리더, 자율 판단·실행), L4 = Worker 218개 스킬(직군 실무자). 본 섹션은 핵심 23개 에이전트만 표로 명시. 플러그인 번들 추가 9개(compound-engineering 등) + L4 Worker 전수 분류는 별도 SSOT 참조: `~/.claude/projects/<slug>/memory/global/reference_tool_catalog.md` (총 263개 도구 전수 분류).

### 핵심 개발 (매일 사용)
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **planner** | 작업 계획 수립, 단계 분해 | **PM**, CTO | 새 기능/복잡한 작업 시작 시 가장 먼저 |
| **code-reviewer** | 코드 품질, 보안, 패턴 리뷰 | **QA** | 구현 완료 후, 배포 전 |
| **build-error-resolver** | 빌드/컴파일 에러 진단 및 해결 | **CTO** | 빌드 실패 시 |
| **security-reviewer** | 보안 취약점 탐지 | **QA** | 코드 리뷰 시, 배포 전 |
| **tdd-guide** | 테스트 주도 개발 가이드 | **CTO** | 새 기능 구현 시 |

### 코드 품질
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **architect** | 시스템 아키텍처 설계 | **CTO** | 새 프로젝트, 구조 변경 시 |
| **code-architect** | 코드 레벨 아키텍처 | **CTO** | 모듈/패키지 구조 결정 시 |
| **refactor-cleaner** | 리팩토링, 코드 정리 | **CTO** | 기술 부채 해소 시 |
| **code-simplifier** | 복잡한 코드 단순화 | **CTO** | 코드 복잡도 감소 필요 시 |
| **typescript-reviewer** | TS 타입 안전성 리뷰 | **CTO** | TypeScript 프로젝트에서 |
| **performance-optimizer** | 성능 병목 분석/최적화 | **CTO** | 느린 코드 발견 시 |
| **silent-failure-hunter** | 숨겨진 에러/조용한 실패 탐지 | **CTO** | 디버깅 시 |
| **database-reviewer** | DB 쿼리/스키마 리뷰 | **CTO** | DB 관련 코드 작성 시 |

### 탐색 & 문서
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **code-explorer** | 코드베이스 탐색/이해 | **CTO** | 새 프로젝트 파악 시 |
| **docs-lookup** | 라이브러리/프레임워크 문서 검색 | **CTO** | API 사용법 확인 시 |
| **doc-updater** | 문서 자동 업데이트 | **CTO** | 코드 변경 후 문서 동기화 |

### 테스트 & 배포
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **e2e-runner** | E2E 테스트 실행/관리 | **QA** | 주요 기능 완성 후 |
| **seo-specialist** | SEO 최적화 | **CGO** | 웹 프로젝트 배포 전 |

### AI 자동 개선 루프 (GAN Harness)
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **gan-planner** | 개선 계획 수립 | **PM** | AI 자동 개선 사이클 시작 시 |
| **gan-generator** | 계획 기반 코드 생성 | **PM** | gan-planner 출력 후 |
| **gan-evaluator** | 생성된 코드 평가/피드백 | **PM** | gan-generator 출력 후 |

### 제품·디자인·그로스
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **product-strategist** | 제품 전략, 사업기획, 프로젝트 목표 정의 | **CPO** | 새 프로젝트/방향성 결정 시 가장 먼저 |
| **market-researcher** | 시장 규모, 경쟁사 분석, 트렌드, 포지셔닝 기회 | **CPO** | product-strategist 전 또는 사업 방향 검토 시 |
| **ux-researcher** | 타겟 사용자 정성/정량 분석, 페르소나, 니즈 파악 | **CPO** | ux-strategist 전 또는 사용자 이해 필요 시 |
| **ux-strategist** | 목표달성형 UX 설계, 사용자 흐름, 전환 설계 | **CDO** | product-strategist 출력 후 |
| **ui-designer** | UI 시안, 컴포넌트 설계, 레이아웃, 비주얼 시스템 | **CDO** | ux-strategist 출력 후 |
| **gui-critic** | 시안/구현물의 비주얼 감도 리뷰, 디테일 개선 | **CDO** | ui-designer 또는 구현 완료 후 |
| **monetization-advisor** | 수익화 포인트 발굴, 과금 모델, 광고 배치 설계 | **CPO** | 제품 어느 정도 완성 후 |
| **growth-marketer** | 홍보 전략, 채널 선정, SEO, 바이럴, 사용자 획득 | **CGO** | 런칭 전후 |

### 콘텐츠 & 라이팅
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **ux-writer** | 한국어 UX Writing (버튼·토스트·에러·빈상태·온보딩·본문). 번역투 교정, 매트릭스 기반 개선안 + 대안 2개 + confidence 반환 | **CDO** | 개별 UI 문구 교정 시, 또는 `/ux-write` 커맨드. 프로젝트 일괄 교정은 `/ux-wash` |

### 운영 도구
| 에이전트 | 역할 | 소속 C-Level | 언제 호출 |
|---|---|---|---|
| **loop-operator** | 반복 작업 루프 제어 | **PM** | 개선 사이클 반복 시 |
| **harness-optimizer** | 에이전트 하니스 설정 최적화 | **PM** | 에이전트 설정 튜닝 시 |

---

## 2. PM Skills 자동 트리거 매핑 (2026-04-21 편입)

L2 디렉터 라우팅과 **병행** 실행. CEO가 `/슬래시 커맨드`를 외우지 않아도 L1이 키워드로 자동 연결. 상세: `memory/global/reference_pm_skills_integration.md`.

| 한국어 트리거 | 자동 호출 커맨드 | 병행 디렉터 | 용도 한 줄 |
|---|---|---|---|
| 새 아이디어, 신규 기획, 뭐 만들까, 초기 탐색, discovery | `/discover` | product-director | 아이디어→가설→실험 4단 원샷 |
| PRD, 기획서, 스펙 작성, 요구사항 정리 | `/write-prd` | pm-director | 8섹션 PRD 템플릿 |
| 북극성, NSM, 핵심 지표 정의 | `/north-star` | growth-director | North Star + 입력 지표 설계 |
| 기능 우선순위, 백로그 정리, 뭐부터 할까 | `prioritize-features` skill | pm-director | Impact × Effort × Risk 매트릭스 |
| 이슈 분류, 요청 트리아지, 고객 요청 정리 | `/triage-requests` | pm-director | 피드백 배치 분류·우선화 |
| 사전 부검, 런칭 전 리스크, 망할 시나리오 | `/pre-mortem` | qa-director | Tigers/Paper Tigers/Elephants 리스크 분류 |
| 이해관계자, 승인 루트, 설득 지도 | `/stakeholder-map` | pm-director | Power × Interest 그리드 |
| 유저 스토리, 백로그 아이템, 스토리 분할 | `/write-stories` | engineering-director | user/job/wwa 3가지 포맷 |
| A/B 테스트 해석, 실험 결과 판단 | `/analyze-test` | product-director | 통계 유의성·샘플·Ship/Stop 결정 |
| 코호트, 리텐션 분석, 잔존율 | `/analyze-cohorts` | product-director | 가입 시점별 리텐션 커브 |
| 배틀카드, 세일즈 대응, 경쟁사 반박 | `/battlecard` | growth-director | 반론·전환 전략 세일즈 카드 |

**나머지 55개 PM Skills**: `SKILL.md`의 description 기반 자동 로드에 맡김. 필요 시 ben이 `/플러그인명:스킬명` 직접 호출.

---

## 3. 공식 도구 자동 트리거 (2026-04-25 편입)

claude-plugins-official 6개 도구(code-review, context7, figma, frontend-design, skill-creator, superpowers) 트리거 매핑은 별도 SSOT 참조: `memory/global/reference_official_tools_integration.md`

핵심: context7(라이브러리 문서)·figma(디자인 URL 즉시)·superpowers(브레인스톰·계획·TDD 등) 자동 호출. ben이 외울 필요 없이 키워드 매칭으로 발동.

---

## 4. 리뷰어 풀 (compound-engineering)

- compound-engineering:review:* 28개
- compound-engineering:document-review:* 7개
- 관리: qa-director가 필요 시 Agent 툴로 동원
- 원칙: 소규모 변경에 대량 동원 금지, 배포 전·대규모 변경 시에만

---

## 5. 호출 플로우 예시 (검토·루프 포함)

표기 규칙: `→ L1` = L1 종합/검토 단계, `→ CEO` = 보고/승인 요청 단계.

| 상황 | 플로우 |
|---|---|
| 새 제품 전체 사이클 | L1 → CPO → CDO → PM → CTO → QA → CGO → L1 종합 → CEO 보고 |
| 기능 1개 추가 | L1 → PM (계획) → CTO (구현) → CTO 리뷰 → 반영 → QA (검증) → L1 → CEO 보고 |
| UI 개선 | L1 → CDO (ui-designer) → CDO 리뷰(gui-critic) → 반영 → CTO (구현) → QA (회귀) → L1 → CEO |
| 긴급 버그 | L1 → CTO (silent-failure-hunter) → CTO 리뷰 → QA (code-reviewer) → L1 → CEO |
| 디자인 감도 높이기 | L1 → CDO (gui-critic → ui-designer 반영 → gui-critic 재크리틱) → L1 → CEO |
| 수익화 검토 | L1 → CPO (monetization-advisor → product-strategist 반영) → L1 → CEO |
| 런칭/홍보 | L1 → CGO (growth-marketer → seo-specialist) → L1 → CEO |
| 배포 전 점검 | L1 → QA (code-reviewer → security-reviewer → e2e-runner) → L1 → **CEO 승인 대기** (배포는 비가역) |
| 성능 문제 | L1 → CTO (performance-optimizer → database-reviewer 합의 → code-reviewer 회귀) → L1 → CEO |
| UI 문구 교정 | L1 → CDO (ux-writer) → L1 검토 → CEO |
| **검토 루프 패턴 (보편)** | L1 → L2 → L3 (실행) → L2 리뷰 (반려) → L3 (반영) → L2 (재리뷰 OK) → L1 종합 → CEO |

---

## 6. 다중 의견 충돌 처리 세부

리뷰어/에이전트 여러 명이 의견을 낸 경우, 5블록의 `🔍 [상위 검토 & 반영]` 안에 다음을 인라인 삽입:

- **Called**: 호출한 에이전트 + 역할
- **Said**: 각자 핵심 의견 (1줄)
- **Decision**: 최종 결정
- **Why**: 선정 기준 (속도/리스크/품질) + 트레이드오프

선택적으로 `Confidence: high/med/low` 표기.

### 충돌 우선순위

- **안전/보안 우선**: security-reviewer가 STOP 시 다른 에이전트 OK여도 중단
- **Priority 순서**: 🔴 CRITICAL > 🟡 IMPORTANT > 🟢 RECOMMENDED (RULES.md 기준)
- **동급 충돌**: CEO에게 선택지 제시, 각 안의 트레이드오프 명시
- **자동 판단 금지**: 리스크 차이가 불분명하면 L1이 임의 결정 안 함

### 금지

- 자명한 합의 반복 ("모두 같은 의견") — 한 줄로 압축
- 사후 합리화 / 가짜 확신
- 전체 transcript 덤프 (토큰 낭비)
- 거짓 리포팅: 실제 호출한 에이전트만 "Called"에 표기. 호출 안 했으면서 참조만 한 경우는 구분 표기

---

## 7. 5블록 리포트 — 상세 포맷 + 단축 모드

> AGENTS_SYSTEM.md 자동 로드 버전엔 핵심만 박혀 있음. 본 섹션은 단축 모드 / 금지 사항 / 멀티 디렉터 Echo 예시 등 세부.

### 단축 모드 (단순 1회 호출만 허용)

L3 1명만 1회 호출하는 단순 작업은 압축 형식 허용:

```text
🧭 L1 → <director> → <L3>
지시: <한 줄>
실행: <한 줄>
검토: <L1 또는 L2 리뷰 한 줄>
결과: <한 줄>
```

**단축 금지 케이스**: 멀티 에이전트 / 검토 사이클 / 루프 / 의견 충돌 → 5블록 전체 사용

### Echo 형식 예시

**단일 디렉터**
```text
🧭 L1 → design-director → ui-designer, gui-critic
```

**멀티 디렉터 (순차)**
```text
🧭 L1 → engineering-director → silent-failure-hunter
     → qa-director → code-reviewer
```

**멀티 디렉터 (병렬)**
```text
🧭 L1 → [engineering-director → performance-optimizer || qa-director → e2e-runner]
```

**L1 직접 처리 (예외)**
```text
🧭 L1 (direct · 메모리 조회)
```

### 포맷 규칙

- 응답 **첫 줄에** 🧭 경로 출력 (공백 줄 후 본문 시작)
- `→` 는 위임, `||`는 병렬, `(direct · 사유)`는 L1 직접 처리
- L3 실무자 여럿일 때 쉼표로 나열
- 경로가 길면 줄바꿈 들여쓰기 허용
