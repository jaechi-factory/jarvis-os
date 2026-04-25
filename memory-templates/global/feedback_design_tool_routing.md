---
name: 디자인 도구 라우팅 룰 v1.0 (Design Tool Routing)
description: 디자인 작업 시 도구 호출 우선순위 룰. 혼합 모델(해석 C) — 탐색·시안·시스템은 새 디자인 스킬 디폴트, 평가·감도·라이팅은 자체 에이전트(한국어 SSOT). 2026-04-25 ben 지시로 받은 디자인 도구 15개 활성 재배분
type: feedback
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 디자인 도구 라우팅 룰 v1.0

**작성**: 2026-04-25
**근거**: ben 명시 지시 — "디자인쪽은 이번에 받은 것들 위주로 세팅" + "미사용에서 이번에 받은 것은 사용 쪽으로 배분"
**SSOT 정합**: `feedback_role_tool_matrix` v1.0 + `reference_tool_catalog` v1.1

---

## Why (ben 지시 배경)

2026-04-25에 디자인 마켓플레이스 3개(designer-skills 8 플러그인, frontend-design-audit, ui-ux-pro-max-skill) + Figma 공식 플러그인 새로 설치. ben이 "받은 도구 활용도 올려라"고 지시 → 디자인 도구 호출 디폴트를 새 도구 우선으로 보강하면서, 한국어 우위 자체 에이전트 SSOT는 유지.

## How to apply

디자인 작업 진입 시 아래 라우팅 룰 따름. 매트릭스 1순위와 충돌하면 매트릭스 우선. 신규 보조 도구는 2~3순위 위치.

---

## 디자인 작업별 호출 우선순위 (혼합 모델 C)

### 강점별 분리 원칙

```
┌─────────────────────────────────────────┐
│ 탐색·시안·시스템·인터랙션               │
│   → 새 디자인 스킬 디폴트                │
│   (designer-skills + ui-ux-pro-max)     │
├─────────────────────────────────────────┤
│ 평가·감도·라이팅                         │
│   → 자체 에이전트 (한국어 SSOT)          │
│   (gui-critic, ux-writer)               │
├─────────────────────────────────────────┤
│ 인터랙션·프로토타입·접근성               │
│   → 새 스킬 적극 활용                    │
│   (interaction-design, prototyping)     │
└─────────────────────────────────────────┘
```

### 작업별 라우팅 표

| 디자인 작업 | 1순위 | 2순위 (신규 보조) | 3순위 (신규 보조) |
|---|---|---|---|
| **UI 시안 작성** | `ui-designer` 에이전트 + `design-screen` 스킬 | `gui-critic`, `ui-ux-pro-max` 메인 | `design`(pro-max), `ui-styling`, `dark-mode-design`, `data-visualization` |
| **컬러·팔레트 탐색** | `ui-ux-pro-max` (161 팔레트) | `color-palette` + `color-system` 묶음 | — |
| **타이포 시스템** | `type-system` + `typography-scale` | `visual-hierarchy` | — |
| **비주얼·브랜드** | `ui-ux-pro-max` (탐색 모드) | `brand`(pro-max), `illustration-style` | — |
| **디자인 시스템 (신규)** | `design-token` + `tokenize` + `create-component` 트리오 | `theming-system`, `pattern-library`, `documentation-template` | `design-system`(pro-max), `design-system-adoption` |
| **인터랙션 설계** | `state-machine` + `design-interaction` 콤보 | `error-handling-ux`, `loading-states` | — |
| **마이크로인터랙션** | `micro-interaction-spec` + `feedback-patterns` | `animation-principles`, `gesture-patterns` | — |
| **프로토타이핑** | `prototype-strategy` + `figma` MCP (Figma 데모) | `prototype-plan` + `frontend-design` (코드 데모) | `version-control-strategy` (Figma 파일 관리) |
| **사용자 리서치** | `ux-researcher` 에이전트 | `design-research:discover` | `diary-study-plan` (장기 추적) |
| **페르소나** | `ux-researcher` 에이전트 (한국어 SSOT) | `design-research:user-persona` | — |
| **인터뷰** | `design-research:interview-script` + `summarize-interview` 페어 | `pm-product-discovery:interview-script` | — |
| **사용자 여정** | `design-research:journey-map` | `ux-strategy:experience-map` | — |
| **사용성 평가** | `gui-critic` 에이전트 (한국어 SSOT) | `frontend-design-audit:evaluate` (15원칙 체계) | `click-test-plan` (네비 정량) |
| **UX 라이팅** | `/ux-write` 커맨드 (한국어 SSOT) | `/ux-wash` (프로젝트 일괄) | — |
| **디자인 QA** | `design-implementation-reviewer` | `figma-design-sync`, `gui-critic` (감도) | `design-review-process` (셀프 리뷰 체계화) |
| **접근성** | `design-systems:accessibility-audit` | `prototyping-testing:accessibility-test-plan` | Chrome DevTools MCP, Playwright MCP 보조 필수 |
| **이해관계자 합의** | `pm-execution:stakeholder-map` | `ux-strategy:stakeholder-alignment` (페어) | — |

---

## 활성 재배분 결과 (15개, ben 지시)

이전 카탈로그에서 ⚪ 미사용 후보였으나 2026-04-25 ben 지시로 활성 보조 위치 배정:

### Designer Skills 9개

| 스킬 | 새 위치 | 활용 |
|---|---|---|
| `design-research:diary-study-plan` | B-7 UX 리서처 3순위 | 장기 사용자 행동 추적 (1주일 앱 사용 일기 등) |
| `ui-design:dark-mode-design` | E-22 UI 디자이너 3순위 | 다크모드 화면 작업 시 |
| `ui-design:data-visualization` | E-22 UI 디자이너 3순위 | 차트·대시보드·통계 화면 |
| `ui-design:illustration-style` | E-23 비주얼 디자이너 2순위 | 브랜드 일러스트 시스템 |
| `ux-strategy:stakeholder-alignment` | C-17 이해관계자 매니저 2순위 | stakeholder-map과 페어 |
| `prototyping-testing:click-test-plan` | B-11 사용성 평가 3순위 | 첫 클릭·네비게이션 정량 검증 |
| `design-ops:design-review-process` | H-36 디자인적 QA 3순위 | 셀프 리뷰 게이트 체계화 |
| `design-ops:version-control-strategy` | E-25 프로토타이퍼 2순위 | Figma 파일·라이브러리 버전 관리 |
| `designer-toolkit:design-system-adoption` | E-24 디자인 시스템 매니저 3순위 | 1인이라도 시스템 도입 전략 가치 |

### UI-UX-Pro-Max 6개

| 스킬 | 새 위치 | 활용 |
|---|---|---|
| `design-system` | E-24 디자인 시스템 매니저 3순위 | 메인 ui-ux-pro-max + 시스템 패턴 별도 탐색 |
| `design` | E-22 UI 디자이너 3순위 | 시안 탐색 보조 |
| `brand` | E-23 비주얼 디자이너 2순위 | 브랜드 가이드 작업 |
| `ui-styling` | E-22 UI 디자이너 3순위 | 스타일링 세부 디테일 |
| `slides` | F-29 기술 문서 작가 2순위 | 발표·공유용 슬라이드 |
| `banner-design` | F-28 마케팅 카피라이터 2순위 | 마케팅 배너 시안 |

---

## 매트릭스 v1.1 보강 사항 (다음 갱신 시 반영)

`feedback_role_tool_matrix.md` v1.0의 다음 직군에 신규 보조 추가 필요:

- B-7, B-11 → 보조 추가
- C-17 → `stakeholder-alignment` 2순위 페어
- E-22 (UI 디자이너) → 3순위 보조 4개 추가 (`design`, `ui-styling`, `dark-mode-design`, `data-visualization`)
- E-23 (비주얼 디자이너) → 2순위 보조 2개 추가 (`brand`, `illustration-style`)
- E-24 (디자인 시스템) → 3순위 보조 2개 추가 (`design-system`, `design-system-adoption`)
- E-25 (프로토타이퍼) → 2순위 보조 (`version-control-strategy`)
- F-28 (마케팅 카피라이터) → 2순위 보조 (`banner-design`)
- F-29 (기술 문서 작가) → 2순위 보조 (`slides`)
- H-36 (디자인적 QA) → 3순위 보조 (`design-review-process`)

매트릭스 v1.1 통합 갱신은 다음 ben 픽 1라운드 끝나고 한꺼번에.

---

## 한계 (정직)

- 보조 도구 활용은 시뮬레이션 매핑. 실호출 시 우열 다를 수 있음
- 1순위(매트릭스·우선순위 맵)와 충돌 안 나게 신규 도구는 모두 2~3순위 위치
- ben의 "이번 받은 것 위주" 지시를 "활용도 올려라"로 해석. "기존 도구를 무시하라" 의미는 아님
- 분기 재검증 권장: 2026-07-25
