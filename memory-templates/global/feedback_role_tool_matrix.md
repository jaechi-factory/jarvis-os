---
name: 직군별 도구 매트릭스 v1.1 (Role-Tool Matrix)
description: 44개 직군에 1순위 도구 매핑. 한국 풀스택 PD 워크플로우 기준 (Profile v2.0 풀스택 올라운더 반영). 이전 5케이스 비교 결과 + 8 카테고리 sub-agent 매핑 종합. 같은 직군 작업 시 이 맵 직진. v1.1 (2026-04-25): G 카테고리 풀스택 가중치 노트 + GAN 트리거 매핑 신규 추가
type: feedback
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 직군별 도구 매트릭스 v1.0

**작성**: 2026-04-25
**근거**: 8 카테고리 병렬 매핑 sub-agent 분석 + 이전 5케이스 비교(`feedback_tool_priority_map.md` v1.0)
**범위**: 8 카테고리 × 44 직군 전수 매핑

---

## Why

218개 스킬·26개 플러그인이 깔려 있어도 매번 후보 비교하면 일관성 흔들림. 직군 = 의사결정 단위로 묶고 1순위를 박아 직진하기 위함.

## How to apply

ben 요청 → 직군 매칭 → 이 맵에서 1순위 직진. 충돌 직군은 컨텍스트별 분기. 공백 직군은 보강 방안 따름. Founder 명시 지정 시 이 맵 무시.

---

## 직군 1순위 매트릭스 (전체 44개)

### A. 제품·사업 전략 (6)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 1 | 사업기획자 | `pm-product-strategy:startup-canvas` 스킬 | `product-strategist` 에이전트 |
| 2 | 시장조사 분석가 | `market-researcher` 에이전트 | `pm-market-research:market-sizing` |
| 3 | 그로스 분석가 | `pm-marketing-growth:north-star-metric` (`/north-star`) | `pm-data-analytics:cohort-analysis` |
| 4 | A/B 테스트 분석가 | `pm-data-analytics:ab-test-analysis` (`/analyze-test`) | `prototyping-testing:a-b-test-design` |
| 5 | 수익모델 설계자 | `monetization-advisor` 에이전트 | `pm-product-strategy:pricing-strategy` |
| 6 | GTM 전략가 | `pm-go-to-market:gtm-strategy` (`/plan-launch`) | `growth-marketer` 에이전트 |

### B. UX 리서치 (5)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 7 | UX 리서처 | `ux-researcher` 에이전트 | `design-research:discover` |
| 8 | 페르소나 분석가 | `ux-researcher` 에이전트 | `design-research:user-persona` |
| 9 | 인터뷰어 | `design-research:interview-script` + `summarize-interview` 페어 | `pm-product-discovery:interview-script` |
| 10 | 사용자 여정 매퍼 | `design-research:journey-map` | `ux-strategy:experience-map` |
| 11 | 사용성 평가 전문가 | `gui-critic` 에이전트 | `design-research:usability-test-plan` |

### C. 서비스 기획·PM (6)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 12 | 서비스 기획자 (PRD) | `pm-execution:create-prd` (`/write-prd`) | `planner` 에이전트 |
| 13 | 백로그 작가 | `pm-execution:user-stories` (`/write-stories` 묶음) | `job-stories` + `wwas` |
| 14 | 우선순위 분석가 | `pm-product-discovery:prioritize-features` | `pm-execution:prioritization-frameworks` |
| 15 | 사전 부검 전문가 | `pm-execution:pre-mortem` (`/pre-mortem`) | — (단독 1순위) |
| 16 | 스프린트 운영자 | `pm-execution:sprint-plan` | `retro` + `release-notes` 묶음 |
| 17 | 이해관계자 매니저 | `pm-execution:stakeholder-map` (`/stakeholder-map`) | — (단독 1순위) |

### D. UX 전략·정보 설계 (4)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 18 | UX 전략가 | `ux-strategist` 에이전트 + `ux-strategy:frame-problem` + `design-brief` 콤보 | `north-star-vision` + `opportunity-framework` |
| 19 | 정보구조 설계자 (IA) ⚠️ | `design-research:card-sort-analysis` | `prototyping-testing:user-flow-diagram` |
| 20 | 인터랙션 디자이너 | `interaction-design:state-machine` + `design-interaction` 콤보 | `error-handling-ux` + `loading-states` |
| 21 | 마이크로인터랙션 설계 | `interaction-design:micro-interaction-spec` + `feedback-patterns` 콤보 | `animation-principles` + `gesture-patterns` |

### E. UI·비주얼 디자인 (5)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 22 | UI 디자이너 | `ui-designer` 에이전트 + `ui-design:design-screen` | `gui-critic` + `ui-ux-pro-max-skill` |
| 23 | 비주얼 디자이너 ⚠️충돌 | `ui-ux-pro-max-skill` (탐색 모드) **OR** `color-palette/system` 묶음 (체계화 모드) | 컨텍스트 분기 (아래 참조) |
| 24 | 디자인 시스템 매니저 ⚠️충돌 | `design-token` + `tokenize` + `create-component` 트리오 (신규 시스템) | `theming-system` + `pattern-library` + `documentation-template` (확장·문서화) |
| 25 | 프로토타이퍼 ⚠️충돌 | `prototype-strategy` + `figma` 플러그인 (Figma 데모) | `prototype-plan` + `frontend-design` (코드 프로토) |
| 26 | 접근성 전문가 ⚠️약함 | `design-systems:accessibility-audit` | `audit-system`, Chrome DevTools MCP 필수 보조 |

### F. 콘텐츠·라이팅 (3)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 27 | UX 라이터 | `/ux-write` 커맨드 | `/ux-wash` (프로젝트 일괄) |
| 28 | 마케팅 카피라이터 | `pm-marketing-growth:value-prop-statements` → `/ux-write` 후처리 2단 | `positioning-ideas` |
| 29 | 기술 문서 작가 | `compound-engineering:ankane-readme-writer` → `/ux-write` 후처리 | `pm-execution:release-notes` |

### G. 개발·엔지니어링 (5)

| # | 직군 | 🥇 1순위 | 🥈 2순위 (보조) |
|---|---|---|---|
| 30 | 시스템 아키텍트 | `architect` 에이전트 | `code-architect` (모듈 한정) |
| 31 | 프론트엔드 구현자 | **Codex MCP** (메모리 룰 강제) | `tdd-guide` (테스트 먼저), `frontend-design` (UI 가이드) |
| 32 | DB 엔지니어 | `database-reviewer` 에이전트 → Codex MCP (실제 SQL 작성) | `architect`, `context7` MCP |
| 33 | 성능 엔지니어 | `performance-optimizer` 에이전트 + `playwright` MCP (실측) | `database-reviewer`, `vercel` MCP |
| 34 | 디버거 | `silent-failure-hunter` 에이전트 | `build-error-resolver`, `code-explorer` |

> **v1.1 풀스택 가중치 (Profile v2.0)**: ben이 코드 직접 읽고 검수 가능. G-30~G-34 모두 영문 도구도 동등 평가, 한국어 보고는 효율 측면. typescript-reviewer/performance-optimizer/architect 활용 빈도 격상 가능. Codex 위임은 "능력 보완"이 아닌 "토큰·속도 효율" 위임.

### H. QA (10)

| # | 직군 | 🥇 1순위 | 🥈 2순위 | 🥉 3순위 |
|---|---|---|---|---|
| 35 | 기획적 QA | `scope-guardian-reviewer` | `spec-flow-analyzer` | `pre-mortem` |
| 36 | 디자인적 QA | `design-implementation-reviewer` | `figma-design-sync` | `gui-critic` (감도) |
| 37 | 프론트 QA | `julik-frontend-races-reviewer` | `test-browser` | `kieran-typescript-reviewer` |
| 38 | 아키텍처 QA | `architecture-strategist` | `pattern-recognition-specialist` | `project-standards-reviewer` |
| 39 | 데이터 QA ⚠️충돌 | `schema-drift-detector` | `data-migration-expert` | `data-integrity-guardian` |
| 40 | 보안 QA ⚠️충돌 | `security-sentinel` (게이트키퍼) | `security-reviewer` (코드 단위) | `security-lens-reviewer` (문서 단위) |
| 41 | 성능 QA | `performance-oracle` | `performance-reviewer` (회귀) | `performance-optimizer` (처방) |
| 42 | 카피·라이팅 QA | `/ux-wash` | `ux-writer` 에이전트 | `every-style-editor` |
| 43 | 접근성 QA ⚠️약함 | `design-systems:accessibility-audit` | `prototyping-testing:accessibility-test-plan` | `frontend-design-audit` (a11y 일부) |
| 44 | 회귀 QA | `e2e-runner` 에이전트 | `e2e` 스킬 | `bug-reproduction-validator` |

---

## 충돌 직군 5개 — 컨텍스트별 분기

### E-23 비주얼 디자이너
- **탐색 모드** (컬러 후보 5개): `ui-ux-pro-max-skill` (161 팔레트)
- **체계화 모드** (토큰 확정·시스템 통합): `color-palette` + `color-system` + `type-system` 스킬 묶음

### E-24 디자인 시스템 매니저
- **신규 시스템 구축**: `design-token` + `tokenize` + `create-component` 트리오
- **기존 시스템 확장·문서화** (당근 SEED 등): `theming-system` + `pattern-library` + `documentation-template`

### E-25 프로토타이퍼
- **최종 산출물 = Figma 데모**: `prototype-strategy` + `figma` 플러그인
- **최종 산출물 = 웹 데모/코드**: `prototype-plan` + `frontend-design` 플러그인

### H-39 데이터 QA
- **schema 변경 단독**: schema-drift-detector
- **마이그레이션 실행**: data-migration-expert
- **데이터 무결성·제약 검증**: data-integrity-guardian
- **표준 패턴**: 셋 다 순차 호출 (drift → migration → integrity)

### H-40 보안 QA
- **게이트키퍼 (STOP 권한)**: security-sentinel — 시크릿 노출·OWASP top 위반 발견 시 즉시 중단
- **코드 변경 단위 점검**: security-reviewer
- **문서 단계 사전 검토 (shift-left)**: security-lens-reviewer
- **표준 패턴**: 문서 → 코드 → 게이트 3중 방어

---

## 공백·약한 영역 4개 — 보강 방안

### D-19 정보구조 설계자 (IA) ⚠️
- **누락 도구**: sitemap, taxonomy, navigation-pattern, content-inventory
- **현 상태**: 앞단(card-sort) + 뒷단(user-flow)만 커버, 중간 "구조 설계" 자체는 PD 수기 채움
- **보강안**: 향후 designer-skills에 IA 정통 스킬 보강 요청, 또는 외부 템플릿 사용

### E-26 접근성 전문가 / H-43 접근성 QA ⚠️
- **누락 도구**: axe-core MCP, lighthouse-a11y, 한국어 스크린리더(NVDA·VoiceOver) 시뮬레이션
- **현 상태**: 시안 단계 audit 가능, 빌드 후 자동 검증 부재
- **보강안**: `accessibility-audit` + `--chrome` (Chrome DevTools) + `--play` (Playwright) 3종 병행 강제. 한국어 스크린리더는 사람 검증 필수
- **추후**: e2e-runner에 a11y 테스트 시나리오 템플릿 추가 또는 axe-playwright 통합 검토

### C-16 스프린트 운영자
- **누락 도구**: 번다운 차트 전용 스킬
- **보강안**: 외부 도구(Jira·Linear) 위임. 80% 커버는 sprint-plan + retro + release-notes로 충분

---

## GAN 자동 개선 트리거 (Profile v2.0 반영)

ben이 GAN 시리즈 활용 패턴 확인됨 (예: ux-writer 라운드 6). 풀스택 올라운더로서 자동 개선 루프 가치 큼.

| 트리거 키워드 | 자동 호출 |
|---|---|
| "자동 개선 루프", "반복 개선", "GAN 돌려" | gan-planner → gan-generator → gan-evaluator |
| "에이전트 설정 튜닝", "하니스 최적화" | harness-optimizer |
| "반복 작업 루프", "loop 돌려" | loop-operator |

---

## QA 트리거 룰 (자동 호출 매핑)

ben이 작업 종류 키워드 던지면 L1이 자동으로 QA 직군 호출.

| 트리거 키워드 | 호출 QA 직군 | 도구 묶음 |
|---|---|---|
| "PRD 썼다", "기획서 완성" | 1 기획적 QA | `scope-guardian-reviewer` + `spec-flow-analyzer` + `pre-mortem` 병렬 |
| "화면 구현 끝", "컴포넌트 만들었다" | 2 디자인 + 3 프론트 | `design-implementation-reviewer` + `gui-critic` + `test-browser` + `julik-races-reviewer` |
| "DB 마이그레이션", "스키마 변경" | 5 데이터 + 6 보안 | `schema-drift-detector` + `data-migration-expert` + `security-sentinel` |
| "배포 직전", "프로덕션 푸시" 🔴 | **풀세트** 1·2·3·6·10 | scope + design + frontend + security + e2e — **Founder 승인 필수 게이트** |
| "성능 느림", "느린 페이지" | 7 성능 | `performance-oracle` 진단 → `optimizer` 처방 → `reviewer` 회귀 |
| "리팩토링", "구조 정리" | 4 아키텍처 | `architecture-strategist` + `pattern-recognition` + `project-standards` |
| "문구", "카피" | 8 카피 QA | `/ux-wash` 또는 `/ux-write` |
| "버그 리포트 들어옴" | 10 회귀 | `bug-reproduction-validator` → `e2e-runner` |
| "PR 리뷰 코멘트 받음" | 보조 | `pr-comment-resolver` + `previous-comments-reviewer` |

**핵심 발견**: ben "QA 항상 부족" 호소는 **도구 부족이 아니라 자동 트리거 부재** 문제로 추정. 트리거 룰을 박아 자동 호출이 핵심.

---

## 한국 PD 워크플로우 핵심 패턴

### 신규 프로젝트 시작 시
```
A-1 사업기획자 (startup-canvas)
  → A-2 시장조사 (market-researcher)
  → A-6 GTM (gtm-strategy)
  → C-12 PRD (create-prd)
  → C-15 사전 부검 (pre-mortem)
  → D-18 UX 전략 (ux-strategist + frame-problem)
  → B-7 UX 리서치 (ux-researcher)
  → E-22 UI 시안 (ui-designer)
  → 구현 (Codex)
  → QA 트리거
```

### 일상 작업 시
```
"이 화면 짜줘" → ui-designer + design-screen
"한국어 좀 봐줘" → /ux-write
"이거 어떻게 측정?" → /north-star
"이거 우선순위?" → prioritize-features
```

### 콘텐츠·문서 마감 패턴 (2단)
- 1단: 도메인 도구로 골격 (value-prop-statements / readme-writer)
- 2단: `/ux-write` 후처리로 한국어 톤·번역투 정리

---

## 메모리 룰 정합성

이 매트릭스는 다음 메모리와 정합:
- `feedback_role_model_absolute` — L1 자율/Founder 승인 분리
- `feedback_codex_delegation_default` — 모든 코드 작성 Codex 위임 (G-31)
- `feedback_ux_writer_spec` — UX 라이팅 SSOT 강제 (F-27)
- `feedback_critical_lens` — 비판적 시각 유지
- `feedback_tool_priority_map` v1.0 — 5케이스 비교 결과 (이 매트릭스 일부 항목의 근거)

---

## 한계 (정직)

- 시뮬레이션 + 정의 분석 기반. 실호출 검증은 5케이스만 (페르소나·경쟁·사용성·라이팅·사업모델)
- 충돌 5건은 컨텍스트 분기 룰로 처리, 신규 비교 라운드 미실시
- 평가자(L1) 한국 PD 친화 편향
- 도구 업데이트 시 우열 바뀔 수 있음 → 분기 재검증 권장 (2026-07-25)
- IA·접근성 영역 도구 부족은 외부 보조 필수
