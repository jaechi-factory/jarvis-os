---
name: 도구 박스 통합 카탈로그 v1.4 (Tool Catalog)
description: 32 Leader 에이전트(핵심 23+번들 9) + 218 Worker 스킬 + 7 Infra MCP 전수 분류. 직군 매핑·빈도·상태 라벨. 미사용 후보 리스트 포함 ({{USER_NAME}} 픽용). v1.4 (2026-04-25): Profile v2.0 풀스택 올라운더 반영, Leader 빈도 5개 격상
type: reference
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 도구 박스 통합 카탈로그 v1.4

**작성**: 2026-04-25 (최초 v1.0) → v1.4 (2026-04-25 같은 날 4차 갱신)
**근거**: `~/.claude/agents/`(38 파일) + `~/.claude/plugins/cache/**/SKILL.md`(218 파일) + `~/.claude/.claude.json` mcpServers + 매트릭스/우선순위 SSOT 2건
**버전 이력**: v1.0 최초 → v1.1 외부 평판 반영 → v1.2 GAN 활성 재배분 → v1.3 디자인 도구 재배분 → v1.4 Profile v2.0 풀스택 반영
**범위**: 전수 인벤토리 + 매트릭스 매핑 + 빈도·상태 라벨 + 미사용 후보 리스트
**참조 SSOT**: `feedback_role_tool_matrix.md` v1.0, `feedback_tool_priority_map.md` v1.0

---

## Why

{{USER_NAME}}(Founder)이 "내 도구 박스 정리하자"고 요청. 이 카탈로그는:
- L3 Leader 32개·L4 Worker ~218개·Infra 7개를 **한 화면에** 노출
- 직군 매핑(`feedback_role_tool_matrix`)에서 1·2순위로 박힌 도구는 "활성", 매핑 0건은 "미사용 후보"
- {{USER_NAME}}이 후보 리스트 보고 직접 픽(유지/비활성/무시) → 불필요한 노이즈 제거 SSOT
- **삭제·비활성은 안 함**. 이 문서는 분류·라벨링까지만. 비가역 액션은 {{USER_NAME}} 명시 승인 필요

---

## 1. 총 통계

### 분류 분포

| 분류 | 카운트 | 비고 |
|---|---|---|
| **L2 디렉터 (C-Level)** | 6 | product / design / engineering / qa / growth / pm |
| **L3 Leader 에이전트** | 32 | `~/.claude/agents/` 디렉토리 (디렉터 6 제외) |
| **L4 Worker 스킬** | 218 | 8 카테고리 × 26 플러그인. 중복 버전 12개 포함 → 실질 ~206 |
| **Infra MCP** | 7 | 외부 시스템 연결 (코드·디자인·DB·브라우저·메모리·문서) |
| **합계** | **263** | 모드/규칙 파일·커맨드는 제외 |

### 빈도 분포 (v1.4 · Profile v2.0 풀스택 올라운더 반영)

| 빈도 | 카운트 | 설명 |
|---|---|---|
| 🔥 자주 | ~35 | 매트릭스 1순위 또는 {{USER_NAME}} 매일 사용 (ux-write, codex, gui-critic, architect, typescript-reviewer 등). 풀스택 5개 격상 |
| 🟡 가끔 | ~75 | 매트릭스 2순위 또는 케이스 한정 사용 (디자인 15 + GAN 5 + 신규 활성화 분 포함) |
| ⚪ 거의 안 씀 | ~153 | 매트릭스 매핑 0건 + 추정 미사용. **{{USER_NAME}} 픽 후보** (v1.3까지 30개 비활성 보관 분리) |

### 출처 분포 (스킬)

| 출처 | 스킬 수 | 비중 |
|---|---|---|
| pm-skills (PM 본진) | 65 | 30% |
| designer-skills (디자인 본진) | 63 | 29% |
| compound-engineering-plugin (CE) | 41 | 19% |
| claude-plugins-official (figma·frontend·skill-creator·superpowers) | 35 | 16% |
| ui-ux-pro-max-skill | 7 | 3% |
| thedotmack/claude-mem (메모리) | 6 | 3% |
| frontend-design-audit | 1 | 0% |

---

## 2. L3 Leader 32개 분류표 (전수)

매트릭스 매핑 = `feedback_role_tool_matrix` 직군 번호. 매핑 0건이면 ⚪ 미사용 후보.

### CPO (product-director) 휘하 4명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **product-strategist** | A-1 (2순위) | 🟡 | 활성 (사업기획 보조) |
| **market-researcher** | A-2 (1순위) ⭐ | 🔥 | 활성 (경쟁사·시장 본진) |
| **ux-researcher** | B-7, B-8 (1순위) ⭐⭐ | 🔥 | 활성 (페르소나·타깃) |
| **monetization-advisor** | A-5 (1순위) ⭐ | 🟡 | 활성 (수익화 검토 시) |

### CDO (design-director) 휘하 4명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **ux-strategist** | D-18 (1순위) ⭐ | 🔥 | 활성 (UX 전략 본진) |
| **ui-designer** | E-22 (1순위) ⭐ | 🔥 | 활성 (UI 시안 본진) |
| **gui-critic** | B-11, E-22, 우선순위 케이스 3 ⭐⭐ | 🔥 | 활성 (사용성 평가 본진) |
| **ux-writer** | F-27 (1순위 SSOT) ⭐ | 🔥 | 활성 (`/ux-write` 백엔드) |

### CTO (engineering-director) 휘하 14명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **architect** | G-30 (1순위), G-32 보조 ⭐ | 🔥 | **v1.4 격상** (사이드 프로젝트 신규 시작 시 첫 호출) |
| **code-architect** | G-30 (2순위) | 🟡 | 활성 (모듈 한정) |
| **planner** | C-12 (2순위), pm/eng 양쪽 | 🔥 | 활성 (계획 수립) |
| **tdd-guide** | G-31 (2순위) | 🔥 | **v1.4 격상** (Profile v2.0 풀스택, 새 기능마다 호출) |
| **refactor-cleaner** | (매핑 없음 · CTO 일상) | 🟡 | 활성 (리팩토링) |
| **code-simplifier** | (매핑 없음) | ⚪ | 미사용 후보 |
| **typescript-reviewer** | (TS 프로젝트 다수 · [예시 프로젝트 A]·my-mbti 등) | 🔥 | **v1.4 격상** (Profile v2.0 TS 본진) |
| **performance-optimizer** | G-33 (1순위), H-41 (3순위) ⭐ | 🔥 | **v1.4 격상** (실측 직접 가능) |
| **database-reviewer** | G-32 (1순위), G-33 (2순위) ⭐ | 🟡 | 활성 (DB 본진) |
| **build-error-resolver** | G-34 (2순위) | 🔥 | 활성 (빌드 실패 시) |
| **silent-failure-hunter** | G-34 (1순위) ⭐ | 🔥 | **v1.4 격상** (디버깅 본진) |
| **code-explorer** | G-34 (2순위) | 🟡 | 활성 (코드 탐색) |
| **docs-lookup** | (매핑 없음 · context7 MCP가 대체) | ⚪ | 미사용 후보 |
| **doc-updater** | (매핑 없음) | ⚪ | 미사용 후보 |

### QA (qa-director) 휘하 3명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **code-reviewer** | (배포 전 풀세트, AGENTS_SYSTEM 핵심) | 🔥 | 활성 |
| **security-reviewer** | H-40 (2순위) ⭐ | 🔥 | 활성 (보안 본진) |
| **e2e-runner** | H-44 (1순위) ⭐ | 🟡 | 활성 (E2E 본진) |

### CGO (growth-director) 휘하 2명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **growth-marketer** | A-6 (2순위) | 🟡 | 활성 (런칭 시) |
| **seo-specialist** | (매핑 없음 · 웹 배포 전 한정) | 🟡 | 활성 |

### PM (pm-director) 휘하 5명

| 에이전트 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| **loop-operator** | (자동 개선 루프 한정) | ⚪ | 미사용 후보 |
| **harness-optimizer** | (에이전트 설정 튜닝 한정) | ⚪ | 미사용 후보 |
| **gan-planner** | (GAN 사이클 한정) | ⚪ | 미사용 후보 |
| **gan-generator** | (GAN 사이클 한정) | ⚪ | 미사용 후보 |
| **gan-evaluator** | (GAN 사이클 한정) | ⚪ | 미사용 후보 |

**Leader 요약**: 활성 24 / 미사용 후보 8 (대부분 GAN+운영 도구). 디자인·UX·QA 본진 8명은 전부 🔥 자주 사용.

---

## 3. L4 Worker 카테고리별 활성·대기 명단

### 3-1. PM Skills 65개 (8 sub-플러그인)

| Sub-플러그인 | 카운트 | 활성 (1·2순위 매핑) | 대기 (보조) | 미사용 후보 (샘플) |
|---|---|---|---|---|
| **pm-execution** | 15 | `create-prd`, `pre-mortem`, `stakeholder-map`, `user-stories`, `prioritization-frameworks`, `sprint-plan`, `retro`, `release-notes` (8) | `job-stories`, `wwas`, `outcome-roadmap`, `summarize-meeting` (4) | `dummy-dataset`, `brainstorm-okrs`, `test-scenarios` (3) |
| **pm-product-discovery** | 13 | `prioritize-features`, `triage-requests`, `interview-script`, `summarize-interview` (4) | `discover`, `setup-metrics`, `brainstorm-experiments-existing`, `brainstorm-ideas-existing`, `opportunity-solution-tree` (5) | `analyze-feature-requests`, `brainstorm-experiments-new`, `brainstorm-ideas-new`, `identify-assumptions-*` (4) |
| **pm-product-strategy** | 12 | `startup-canvas` ⭐ (우선순위 케이스 5), `lean-canvas`, `pricing-strategy`, `monetization-strategy` (4) | `value-proposition`, `product-vision`, `product-strategy`, `swot-analysis` (4) | `business-model` (구식·비추), `ansoff-matrix`, `porters-five-forces`, `pestle-analysis` (4) |
| **pm-market-research** | 7 | `market-sizing`, `competitor-analysis` (2순위) (2) | `customer-journey-map`, `user-segmentation` (2) | `user-personas` (B2B 톤·비추), `market-segments`, `sentiment-analysis` (3) |
| **pm-marketing-growth** | 5 | `north-star-metric` ⭐ (A-3 1순위), `value-prop-statements` (F-28 2단), `positioning-ideas` (F-28 보조) (3) | `marketing-ideas` (1) | `product-name` (1) |
| **pm-go-to-market** | 6 | `gtm-strategy` ⭐ (A-6 1순위), `competitive-battlecard`, `growth-loops` (3) | `gtm-motions`, `ideal-customer-profile`, `beachhead-segment` (3) | — |
| **pm-data-analytics** | 3 | `ab-test-analysis` ⭐ (A-4 1순위), `cohort-analysis` ⭐ (A-3 2순위), `sql-queries` (3) | — | — |
| **pm-toolkit** | 4 | `grammar-check` (1) | `review-resume` (1) | `draft-nda`, `privacy-policy` (2) |

**PM 합계**: 활성 28 / 대기 19 / 미사용 후보 18

### 3-2. Designer Skills 63개 (8 sub-플러그인)

| Sub-플러그인 | 카운트 | 활성 | 대기 | 미사용 후보 (샘플) |
|---|---|---|---|---|
| **design-research** | 10 | `interview-script`+`summarize-interview` 페어 ⭐ (B-9 1순위), `journey-map` ⭐ (B-10 1순위), `user-persona` (2순위), `discover` (B-7 보조), `card-sort-analysis` ⭐ (D-19 1순위), `usability-test-plan` (B-11 2순위) (7) | `affinity-diagram`, `empathy-map`, `jobs-to-be-done` (3) | `diary-study-plan` (1) |
| **ui-design** | 9 | `design-screen` ⭐ (E-22 1순위), `color-palette`+`color-system` (E-23 체계화), `type-system`/`typography-scale` (E-23) (5) | `responsive-design`, `responsive-audit`, `spacing-system`, `layout-grid`, `visual-hierarchy` (5) | `dark-mode-design`, `data-visualization`, `illustration-style` (3) |
| **ux-strategy** | 8 | `frame-problem`+`design-brief` 콤보 ⭐ (D-18 1순위), `north-star-vision`, `opportunity-framework` (D-18 2순위), `competitive-analysis` (4) | `experience-map` (B-10 2순위), `metrics-definition`, `design-principles` (3) | `stakeholder-alignment` (1) |
| **prototyping-testing** | 8 | `a-b-test-design` (A-4 2순위), `accessibility-test-plan` (H-43 2순위), `prototype-strategy`+`prototype-plan` (E-25 분기), `user-flow-diagram` (D-19 2순위) (5) | `heuristic-evaluation`, `test-scenario`, `wireframe-spec` (3) | `click-test-plan` (1) |
| **design-systems** | 8 | `design-token`+`tokenize`+`create-component` 트리오 ⭐ (E-24 1순위), `theming-system`+`pattern-library`+`documentation-template` (E-24 2순위), `accessibility-audit` ⭐ (E-26·H-43 1순위), `audit-system` (E-24 보조) (8) | — | — |
| **interaction-design** | 7 | `state-machine`+`design-interaction` 콤보 ⭐ (D-20 1순위), `error-handling-ux`+`loading-states` (D-20 2순위), `micro-interaction-spec`+`feedback-patterns` 콤보 ⭐ (D-21 1순위), `animation-principles`+`gesture-patterns` (D-21 2순위) (7) | — | — |
| **design-ops** | 7 | `handoff-spec`/`handoff` (1) | `design-critique`, `design-qa-checklist`, `design-sprint-plan`, `team-workflow` (4) | `design-review-process`, `version-control-strategy` (2) |
| **designer-toolkit** | 6 | `ux-writing` (F-27 비추 명시) (1) | `design-rationale`, `case-study`, `presentation-deck` (3) | `design-system-adoption`, `design-token-audit` (2) |

**Designer 합계**: 활성 37 / 대기 18 / 미사용 후보 9

### 3-3. Compound-Engineering 41개

{{USER_NAME}} 작업 흐름 기준 분류:

| 그룹 | 카운트 | 활성 | 미사용 후보 (샘플) |
|---|---|---|---|
| **Git/PR 워크플로** | 5 | `git-commit`, `git-commit-push-pr`, `git-clean-gone-branches`, `git-worktree`, `resolve-pr-feedback` | — |
| **CE Core (계획·작업)** | 7 | `ce-plan`, `ce-work`, `ce-brainstorm`, `ce-review`, `ce-ideate` (5) | `ce-compound`, `ce-compound-refresh` (2) |
| **TODO 관리** | 3 | `todo-create`, `todo-resolve`, `todo-triage` (3) | — |
| **테스트·디버그** | 4 | `test-browser`, `reproduce-bug`, `report-bug-ce` (3) | `test-xcode` (iOS 미사용) (1) |
| **에이전트 인프라** | 4 | `agent-browser`, `agent-native-architecture`, `agent-native-audit` (3) | `orchestrating-swarms` (1) |
| **콘텐츠·문서** | 5 | `every-style-editor` (F 카피 QA), `frontend-design`, `document-review` (3) | `andrew-kane-gem-writer` (Ruby 한정), `dhh-rails-style` (Rails 한정) (2) |
| **이미지·미디어** | 2 | — | `gemini-imagegen`, `feature-video` (2) |
| **운영 도구** | 11 | `claude-permissions-optimizer`, `onboarding`, `setup`, `lfg`, `slfg`, `claude-mem` 일부 (6) | `proof`, `rclone`, `dspy-ruby`, `deploy-docs`, `changelog` (5) |

**CE 합계**: 활성 26 / 미사용 후보 15

### 3-4. Claude-Plugins-Official (figma·frontend·skill-creator·superpowers) 35개 (중복 12개 포함)

| 그룹 | 실질 카운트 | 상태 |
|---|---|---|
| **figma** (figma-use, figma-implement-design 등 7개) | 7 | 🟡 활성 (Figma 작업 시) |
| **frontend-design** (7개 중복 버전 → 1개) | 1 | 🟡 활성 (E-25 코드 프로토) |
| **skill-creator** (7개 중복 버전 → 1개) | 1 | ⚪ 미사용 후보 (스킬 직접 만들 때만) |
| **superpowers** 14개 | 14 | 활성 11 (`brainstorming`, `executing-plans`, `writing-plans`, `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `using-superpowers`, `subagent-driven-development`, `finishing-a-development-branch`) / 대기 3 (`writing-skills`, `using-git-worktrees`, deprecated 항목) |

**Official 합계**: 활성 22 / 미사용 후보 1

### 3-5. UI-UX-Pro-Max-Skill 7개

| 스킬 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| `ui-ux-pro-max` (메인) | E-23 (탐색 모드) ⭐ | 🟡 | 활성 (161 팔레트 탐색) |
| `design-system`, `design`, `brand` | (매핑 없음) | ⚪ | 미사용 후보 |
| `ui-styling`, `slides`, `banner-design` | (매핑 없음) | ⚪ | 미사용 후보 |

**합계**: 활성 1 / 미사용 후보 6

### 3-6. Thedotmack/Claude-Mem 6개

| 스킬 | 빈도 | 상태 |
|---|---|---|
| `mem-search`, `make-plan`, `do` | 🟡 | 활성 (메모리·계획) |
| `smart-explore`, `timeline-report` | ⚪ | 미사용 후보 |
| `version-bump` | ⚪ | 미사용 후보 (플러그인 개발 시만) |

**합계**: 활성 3 / 미사용 후보 3

### 3-7. Frontend-Design-Audit 1개

| 스킬 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|
| `frontend-design-audit` | 우선순위 케이스 3 (병행 추천) ⭐ | 🟡 | 활성 (15원칙 체계 검증) |

**합계**: 활성 1

### 3-8. Worker 총합

| 출처 | 활성 | 대기 | 미사용 후보 |
|---|---|---|---|
| PM Skills | 28 | 19 | 18 |
| Designer Skills | 37 | 18 | 9 |
| Compound-Engineering | 26 | — | 15 |
| Official (figma+frontend+sc+sp) | 22 | — | 1 |
| UI-UX-Pro-Max | 1 | — | 6 |
| Claude-Mem | 3 | — | 3 |
| Frontend-Design-Audit | 1 | — | — |
| **합계 (218)** | **118** | **37** | **52** (중복 11개 별도) |

비중: 활성 54% / 대기 17% / 미사용 후보 24% / 중복 5%.

---

## 4. Infra MCP 7개 표

| MCP | 역할 | 매트릭스 매핑 | 빈도 | 상태 |
|---|---|---|---|---|
| **codex-cli** | GPT-5 코드 작성·세컨드 오피니언 (`mcp__codex-cli__codex`) | G-31, G-32 1순위 ⭐⭐ | 🔥 | 활성 (코드 작성 디폴트) |
| **github** | PR/이슈/리뷰 (gh CLI 보완) | (개발 워크플로 보조) | 🔥 | 활성 (PR 작성 시) |
| **playwright** | 브라우저 자동화·E2E·실측 | G-33 (성능 실측) ⭐, H-44 보조 | 🟡 | 활성 (E2E·성능 실측) |
| **context7** | 라이브러리 공식 문서 조회 | G-32 (DB 보조) | 🟡 | 활성 (라이브러리 사용 시) |
| **figma** | Figma 디자인 컨텍스트 추출 | E-25 (Figma 데모) ⭐ | 🟡 | 활성 (Figma 작업 시) |
| **claude-mem** | 메모리 검색·저장 (`mcp__plugin_claude-mem_mcp-search__*`) | (메모리 본진) | 🟡 | 활성 (메모리 검색) |
| **vercel** | 배포 인증 (`mcp__vercel__authenticate`) | (배포 시) | 🟡 | 활성 (Vercel 배포) |

**그 외 OAuth 전용** (인증만 제공, 본 MCP는 별도 사용):
- `claude_ai_Gmail` / `Google_Calendar` / `Google_Drive` / `notion` — Founder 명시 사용 시만 활성

**Infra 합계**: 7 (모두 활성, 일상 빈도 차이만 있음)

---

## 5. 자주 쓰는 도구 톱 30 (🔥 빈도) — v1.4 갱신

Profile v2.0 풀스택 올라운더 반영. 풀스택 도구 5개(architect, typescript-reviewer, silent-failure-hunter, tdd-guide, performance-optimizer) 신규 진입. 일부 PM 도구는 사이드 프로젝트 빈도 낮아 후순위로.

| # | 도구 | 분류 | 핵심 사용 |
|---|---|---|---|
| 1 | **codex-cli MCP** | Infra | 모든 코드 작성 (효율 위임, `feedback_codex_delegation_default`) |
| 2 | **/ux-write 커맨드** | Worker | 한국어 UI 문구 교정 (우선순위 케이스 4 1순위) |
| 3 | **gui-critic 에이전트** | Leader | UI 사용성·감도 평가 |
| 4 | **ui-designer 에이전트** | Leader | UI 시안 본진 (E-22) |
| 5 | **ux-strategist 에이전트** | Leader | UX 전략 (D-18) |
| 6 | **planner 에이전트** | Leader | 모든 멀티스텝 작업 시작 |
| 7 | **code-reviewer 에이전트** | Leader | 구현 후 필수 호출 |
| 8 | **build-error-resolver** | Leader | 빌드 실패 시 자동 호출 |
| 9 | **silent-failure-hunter** 🆕 | Leader | 디버깅 본진 (Profile v2.0 격상) |
| 10 | **typescript-reviewer** 🆕 | Leader | TS 프로젝트 다수 ([예시 프로젝트 A]·my-mbti 등, 격상) |
| 11 | **architect** 🆕 | Leader | 사이드 프로젝트 신규 시작 첫 호출 (격상) |
| 12 | **tdd-guide** 🆕 | Leader | 새 기능마다 (Profile v2.0 격상) |
| 13 | **performance-optimizer** 🆕 | Leader | 성능 실측·처방 (격상) |
| 14 | **security-reviewer** | Leader | 배포 전 (H-40) |
| 15 | **github MCP** | Infra | PR·이슈 |
| 16 | **ux-researcher 에이전트** | Leader | 페르소나·타깃 분석 |
| 17 | **market-researcher 에이전트** | Leader | 경쟁사·시장 |
| 18 | **/write-prd (pm-execution:create-prd)** | Worker | PRD 작성 (C-12 1순위) |
| 19 | **/pre-mortem (pm-execution:pre-mortem)** | Worker | 사전 부검 (C-15 1순위) |
| 20 | **/north-star (pm-marketing-growth)** | Worker | 핵심 지표 (A-3 1순위) |
| 21 | **figma MCP + figma-use 스킬** | Infra+Worker | Figma 작업 시 페어 (E-25) |
| 22 | **context7 MCP** | Infra | 라이브러리 문서 (Profile v2.0 풀스택 빈도 상승) |
| 23 | **startup-canvas 스킬** | Worker | 사업 모델 |
| 24 | **/prioritize-features** | Worker | 우선순위 매트릭스 |
| 25 | **/stakeholder-map** | Worker | 이해관계자 |
| 26 | **superpowers:brainstorming + writing-plans + executing-plans** | Worker | 새 기능 시작 |
| 27 | **interaction-design:state-machine** | Worker | 인터랙션 본진 (D-20) |
| 28 | **design-systems:design-token + tokenize + create-component 트리오** | Worker | 디자인 시스템 (E-24) |
| 29 | **design-systems:accessibility-audit** | Worker | 접근성 |
| 30 | **playwright MCP** | Infra | 성능 실측·E2E (Profile v2.0 풀스택 빈도 상승) |

**v1.4 관찰**: Leader 13 / Worker 11 / Infra 6. 풀스택 격상으로 Leader·Infra 비중 확대. PM 도구는 사이드 프로젝트 빈도 낮은 일부(/analyze-test, /analyze-cohorts, /triage-requests, /battlecard) 후순위로 빠짐 — 필요 시 자동 트리거로 호출.

---

## 6. 미사용 후보 리스트 ({{USER_NAME}} 픽용)

매트릭스 매핑 0건 + 매일 작업과 거리 먼 도구. **삭제·비활성 안 함**. {{USER_NAME}}이 카테고리별로 픽:

- **유지** (혹시 모를 케이스 대비 그대로 둠)
- **비활성** (settings.json `disabledMcpjsonServers`/`disabledPlugins`에 추가)
- **무시** (그냥 두고 자동 매칭에서 빠짐)

### 6-1. PM Skills 미사용 후보 18개

| 스킬 | 사유 | {{USER_NAME}} 픽 |
|---|---|---|
| pm-product-strategy:business-model | 우선순위 맵에서 "구식" 명시 | □ 유지 □ 비활성 □ 무시 |
| pm-product-strategy:ansoff-matrix | 대기업 전략 프레임, PD 사용 거의 없음 | □ □ □ |
| pm-product-strategy:porters-five-forces | 동상 (PESTLE도 동상) | □ □ □ |
| pm-product-strategy:pestle-analysis | 매크로 환경 분석 (PD 작업 거리 멈) | □ □ □ |
| pm-product-discovery:brainstorm-experiments-new | "new" 버전 (existing이 본진) | □ □ □ |
| pm-product-discovery:brainstorm-ideas-new | 동상 | □ □ □ |
| pm-product-discovery:identify-assumptions-new/existing | 추상적 분석, {{USER_NAME}} 사용 흔적 없음 | □ □ □ |
| pm-product-discovery:analyze-feature-requests | triage-requests와 중복 | □ □ □ |
| pm-execution:dummy-dataset | 코드 작업 (Codex가 대체) | □ □ □ |
| pm-execution:brainstorm-okrs | OKR 도입 안 함 (1인 운영) | □ □ □ |
| pm-execution:test-scenarios | QA 직군 도구가 대체 | □ □ □ |
| pm-marketing-growth:product-name | 제품명 짓기, 단발성 | □ □ □ |
| pm-market-research:user-personas | "B2B 코퍼릿 톤" 비추 명시 (ux-researcher가 1순위) | □ □ □ |
| pm-market-research:market-segments | 단발성 사용 | □ □ □ |
| pm-market-research:sentiment-analysis | 자체 데이터 분석 환경 부족 | □ □ □ |
| pm-toolkit:draft-nda | 1인 운영, NDA 거의 없음 | □ □ □ |
| pm-toolkit:privacy-policy | 단발성 (앱 출시 1회) | □ □ □ |

### 6-2. Designer Skills (이전 미사용 9개) → ✅ 활성 재배분 완료 (2026-04-25 {{USER_NAME}} 지시)

{{USER_NAME}}이 "이번에 받은 디자인 플러그인은 사용 쪽으로 배분"하라고 명시. 9개 모두 ⚪ → 🟡 활성(보조). 신규 매핑은 `feedback_design_tool_routing.md` 참조.

| 스킬 | 신규 매핑 | 빈도 |
|---|---|---|
| design-research:diary-study-plan | B-7 UX 리서처 3순위 보조 (장기 사용자 행동 추적) | 🟡 |
| ui-design:dark-mode-design | E-22 UI 디자이너 3순위 보조 (다크모드 화면 작업) | 🟡 |
| ui-design:data-visualization | E-22 UI 디자이너 3순위 보조 (차트·대시보드) | 🟡 |
| ui-design:illustration-style | E-23 비주얼 디자이너 2순위 (브랜드 일러스트) | 🟡 |
| ux-strategy:stakeholder-alignment | C-17 이해관계자 매니저 2순위 (stakeholder-map 페어) | 🟡 |
| prototyping-testing:click-test-plan | B-11 사용성 평가 3순위 (네비게이션 정량 검증) | 🟡 |
| design-ops:design-review-process | H-36 디자인적 QA 3순위 (셀프 리뷰 체계화) | 🟡 |
| design-ops:version-control-strategy | E-25 프로토타이퍼 2순위 (Figma 파일 버전 관리) | 🟡 |
| designer-toolkit:design-system-adoption | E-24 디자인 시스템 매니저 3순위 (시스템 도입 전략) | 🟡 |

### 6-3. Compound-Engineering 미사용 후보 15개

| 스킬 | 사유 | {{USER_NAME}} 픽 |
|---|---|---|
| ce-compound, ce-compound-refresh | "knowledge compounding" 메타, {{USER_NAME}} 사용 패턴 외 | □ □ □ |
| test-xcode | iOS 네이티브 미사용 | □ □ □ |
| orchestrating-swarms | 대형 멀티 에이전트 (overkill) | □ □ □ |
| andrew-kane-gem-writer | Ruby gem 미사용 | □ □ □ |
| dhh-rails-style | Rails 미사용 | □ □ □ |
| dspy-ruby | Ruby DSPy 미사용 | □ □ □ |
| gemini-imagegen | 이미지 생성 (Figma·다른 도구 대체) | □ □ □ |
| feature-video | PR 비디오 (1인 무관) | □ □ □ |
| proof | 마크다운 협업 도구 (Notion 대체) | □ □ □ |
| rclone | 파일 동기화 (단발성) | □ □ □ |
| changelog | release-notes가 대체 | □ □ □ |
| deploy-docs | 문서 배포 (Vercel 대체) | □ □ □ |

### 6-4. UI-UX-Pro-Max (이전 미사용 6개) → ✅ 활성 재배분 완료 (2026-04-25 {{USER_NAME}} 지시)

| 스킬 | 신규 매핑 | 빈도 |
|---|---|---|
| design-system | E-24 디자인 시스템 매니저 3순위 (탐색 모드 패턴) | 🟡 |
| design | E-22 UI 디자이너 3순위 (시안 탐색 보조) | 🟡 |
| brand | E-23 비주얼 디자이너 2순위 (브랜드 가이드 작업) | 🟡 |
| ui-styling | E-22 UI 디자이너 3순위 (스타일링 세부) | 🟡 |
| slides | F-29 기술 문서 작가 2순위 (발표·공유용) | 🟡 |
| banner-design | F-28 마케팅 카피라이터 2순위 (마케팅 배너 시안) | 🟡 |

### 6-5. Claude-Mem 미사용 후보 3개

| 스킬 | 사유 | {{USER_NAME}} 픽 |
|---|---|---|
| smart-explore | tree-sitter 코드 검색 (Grep 대체) | □ □ □ |
| timeline-report | 프로젝트 회고 narrative (단발성) | □ □ □ |
| version-bump | 플러그인 개발 시만 ({{USER_NAME}} 작업 외) | □ □ □ |

### 6-6. Leader 에이전트 (이전 미사용 8개) → ✅ GAN 5개 활성 재배분 (2026-04-25 v1.2, {{USER_NAME}} 사용 패턴 + Profile v2.0)

{{USER_NAME}}이 "GAN 한 번씩 잘 썼다" 명시 + User Profile v2.0(풀스택 올라운더) 반영. GAN 시리즈 + 페어 도구 5개는 활성 유지.

**활성 재배분 5개**:
| 에이전트 | 신규 빈도 | 활용 |
|---|---|---|
| gan-planner | 🟡 가끔 | 자동 개선 사이클 시작 시 |
| gan-generator | 🟡 가끔 | gan-planner 후속 |
| gan-evaluator | 🟡 가끔 | gan-generator 후속 (rubric 기반 평가) |
| loop-operator | 🟡 가끔 | 반복 개선 루프 제어 |
| harness-optimizer | 🟡 가끔 | 에이전트 설정 튜닝 |

**남은 미사용 후보 3개 (Leader)**:
| 에이전트 | 사유 | {{USER_NAME}} 픽 |
|---|---|---|
| code-simplifier | refactor-cleaner와 중복 | □ 유지 □ 비활성 □ 무시 |
| docs-lookup | context7 MCP가 대체 | □ □ □ |
| doc-updater | 자동 문서 동기화 (수동 작업으로 대체 가능) | □ □ □ |

**미사용 후보 합계 (v1.4 갱신, 2026-04-25)**: 27 워커 + 3 리더 = **30개** (전체 263 중 11%)
— v1.1: 디자인 15개(Designer 9 + UI-UX-Pro-Max 6) 활성 재배분
— v1.2: Leader GAN 5개 활성 재배분 ({{USER_NAME}} 실사용 패턴 + Profile v2.0)
— v1.3: 명확한 9개(CE 5 + PM "new" 4) **비활성 보관** ({{USER_NAME}} "전부 허가" 명시 승인)
— **v1.4: Profile v2.0 풀스택 올라운더 반영 — Leader 빈도 5개 격상 (architect, typescript-reviewer, performance-optimizer, silent-failure-hunter, tdd-guide), 톱 30 재배열, 빈도 분포 갱신 (🔥 30→35, ⚪ 163→153)**
— 남은 {{USER_NAME}} 픽 대상: PM Skills 14 + Compound-Engineering 10 + Claude-Mem 3 + Leader 3 = **30개**

---

## 6-7. 비활성 보관 (자동 매칭 제외) — v1.3 (2026-04-25)

{{USER_NAME}} "비활성 진행" 명시 승인. L1 자동 매칭에서 이 9개 제외. 직접 호출 시(`/플러그인:스킬명`)는 여전히 작동. 가역적 — 다시 활성화 원하면 이 섹션에서 빼면 됨.

| 도구 | 출처 | 비활성 사유 |
|---|---|---|
| andrew-kane-gem-writer | compound-engineering | Ruby gem 미사용 (TS/React 스택) |
| dhh-rails-style | compound-engineering | Rails 미사용 |
| dspy-ruby | compound-engineering | Ruby DSPy 미사용 |
| test-xcode | compound-engineering | iOS 네이티브 미사용 |
| feature-video | compound-engineering | PR 비디오 (1인 운영 무관) |
| brainstorm-experiments-new | pm-product-discovery | "existing" 본진과 중복 |
| brainstorm-ideas-new | pm-product-discovery | "existing" 본진과 중복 |
| identify-assumptions-new | pm-product-discovery | "existing" 본진과 중복 |
| identify-assumptions-existing | pm-product-discovery | (이건 "existing"인데 잘 안 씀, 검토 후 비활성. 신규 제품 작업 시 활성화 필요) |

**자동 매칭 제외 룰 적용**: L1이 도구 매칭 시 이 표 먼저 확인 → 제외 후 다음 후보로.

---

## 7. 한계·갱신 정책

### 한계 (정직)

- **빈도 추정 기반**: 실제 호출 로그 분석 X. 매트릭스 1순위 매핑 + {{USER_NAME}} 일상 작업 추정으로 라벨링.
- **중복 버전 미정리**: skill-creator·frontend-design·figma 등 7개 중복 버전 존재. 실질 카운트 불일치 가능 (218 vs ~206).
- **PM Skills 65개 중 일부는 슬래시 커맨드 + 스킬 양쪽 등록**: `/write-prd`(슬래시) + `pm-execution:create-prd`(스킬) 같은 페어가 다수. 실 호출 단위는 ~36 슬래시 + ~29 직접 스킬.
- **삭제·비활성 결정은 {{USER_NAME}} 권한**: 이 카탈로그는 분류·라벨링까지. 비가역 액션은 명시 승인 필요.
- **매트릭스/우선순위 맵 미검증 영역**: 215개 스킬은 시뮬레이션 미실시. 실전 호출하면 우열 바뀔 수 있음.

### 갱신 정책

- **분기별 재검증**: 2026-07-25 권장 (도구 업데이트로 우열 바뀔 수 있음)
- **신규 도구 설치 시**: 카탈로그 즉시 업데이트 (출처·카테고리·매트릭스 매핑 추가)
- **{{USER_NAME}} 픽 결과 반영**: 미사용 후보 리스트에서 비활성 결정된 도구는 별도 섹션 8 "비활성 보관" 추가
- **자주 쓰는 도구 톱 30 검증**: 월 1회 호출 빈도 측정 (수동 또는 로그 기반)

### 메모리 룰 정합성

이 카탈로그는 다음과 정합:
- `feedback_role_tool_matrix` v1.0 — 직군별 1순위 도구 매트릭스 (이 카탈로그의 활성 라벨 근거)
- `feedback_tool_priority_map` v1.0 — 5케이스 비교 결과 (⭐ 표기 근거)
- `feedback_codex_delegation_default` — Codex MCP가 코드 작성 1순위 (G-31)
- `feedback_ux_writer_spec` — `/ux-write` SSOT (F-27)
- `feedback_pm_skills_integration` — PM Skills 자동 트리거 11개 매핑
- AGENTS_SYSTEM.md — 5단 조직도 (Founder/L1/L2/L3/L4)

---

## 부록: 인벤토리 출처 명령어

```bash
# 에이전트 (38개)
find ~/.claude/agents -maxdepth 2 -name "*.md" -type f | sort

# 스킬 (218개)
find ~/.claude/plugins/cache -name "SKILL.md" -type f | sort

# 플러그인별 카운트
find ~/.claude/plugins/cache -name "SKILL.md" | awk -F'/' '{print $7"/"$8}' | sort | uniq -c | sort -rn

# MCP 서버
grep -A 30 "mcpServers" ~/.claude/.claude.json
# 또는: claude mcp list
```
