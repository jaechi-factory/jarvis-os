---
name: 도구 우선순위 맵 (Tool Priority Map v1.0)
description: 자주 헷갈리는 5개 케이스에 대해 비교 라운드로 결정한 1순위 도구. 한국어 PD 작업 기준. 같은 도메인 후보가 여러 개일 때 이 맵을 따름
type: feedback
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 도구 우선순위 맵 v1.0

**작성**: 2026-04-25
**근거**: 5개 케이스 병렬 비교 라운드 (general-purpose sub-agent 5명, 각자 같은 입력으로 후보 도구 정의 분석 + 결과 시뮬레이션)
**범위**: 218개 스킬·26개 플러그인 중 자주 충돌하는 5개 케이스. 나머지는 실전 누적 평가(C 방식)로 보강

---

## Why (왜 이 룰을 박는가)

ben이 한국 PD라 같은 카테고리에 여러 도구가 있으면 매번 후보 비교하느라 일관성 흔들림. 비교 라운드 1회로 케이스별 1순위를 정하고 직진하기 위함.

## How to apply (언제 이 맵을 쓰는가)

같은 도메인에 후보가 2개 이상 매칭될 때 → 이 맵 1순위로 직진. Founder가 명시 지정하면 그게 우선 (이 맵 무시).

---

## 케이스별 1순위 (5건)

| # | 케이스 | 🥇 1순위 | 🥈 2순위 (언제) | 🥉 사용 비추천 |
|---|---|---|---|---|
| 1 | 사용자 페르소나 | **AGENT `ux-researcher`** (44/50) | `design-research:user-persona` — 발표·포트폴리오용 감정·서사 페르소나 | `pm-market-research:user-personas` (B2B 코퍼릿 톤) |
| 2 | 경쟁사 분석 | **AGENT `market-researcher`** (39/50) | `pm-market-research:competitor-analysis` — 영문 IR/투자자용 풀 리포트 | — (3순위 ux-strategy는 단독 X, 보조용) |
| 3 | 사용성 평가 | **AGENT `gui-critic`** (41/50) | `frontend-design-audit:evaluate` — 15원칙 체계 검증 필요 시 (병행 추천) | `design-systems:audit-system` (단일 화면 부적합, 시스템 점검용) |
| 4 | UX 라이팅 | **COMMAND `/ux-write`** (48/50) ⭐ | `ux-writer` 에이전트 단독 — 자동화·배치 처리에서 raw JSON 필요 시 | `designer-toolkit:ux-writing` (영문 일반론, 한국어 매트릭스 부재) |
| 5 | 사업 모델 캔버스 | **SKILL `startup-canvas`** (41/50) | `lean-canvas` — 30분 안에 가설 1장 + 인터뷰 5건 검증 들어갈 때 | `business-model` BMC 9블록 (Vision·방어성·핵심지표 누락. 구식) |

---

## 패턴 인사이트 (5케이스 종합)

### 1. 한국어 네이티브가 거의 항상 이긴다
케이스 1·2·3·4 = 한국어로 작성된 자체 에이전트(`~/.claude/agents/`)가 1순위. 영문 SKILL은 PD 톤·번역투 회피 면에서 손해. **예외**: 케이스 5 — "캔버스" 같은 정형 프레임워크가 필요할 땐 영문 SKILL이 깊이로 이김.

### 2. 에이전트 > 스킬 (자율 실행 우위)
4/5 케이스에서 에이전트가 1순위 또는 동급. 이유: 에이전트는 자율로 추가 리서치/계산 수행, 스킬은 템플릿 채우기만. 단, **명확한 프레임워크 산출물(BMC·Lean Canvas 등)이 필요할 땐 스킬**.

### 3. 커맨드 레이어가 있으면 커맨드 우선
케이스 4 = `/ux-write` 커맨드가 ux-writer 에이전트보다 우위. 이유: 커맨드가 raw JSON을 PD 친화 포맷으로 변환. **룰**: 같은 SSOT 참조하는 커맨드 + 에이전트 페어가 있으면 커맨드 우선.

### 4. PM Skills 디폴트 비추 (PD 작업 기준)
PM Skills는 5케이스 중 어느 것도 1순위 못 함. B2B·코퍼릿 톤이 PD 작업과 미스매치. **예외**: PRD 작성(`/write-prd`), 우선순위 매트릭스(`/prioritize-features`), 사전 부검(`/pre-mortem`) 같은 PM 본진 작업은 그대로 PM Skills 사용.

### 5. Designer Skills도 한 톤 무거움
디자이너 플러그인이지만 영문이고 분량 짧은 경우 많음. 자체 에이전트가 더 한국 PD 친화적인 케이스 다수.

---

## 적용 룰 (강제)

1. **이 맵에 있는 5케이스는 1순위 직진**. 후보 비교 생략.
2. **이 맵에 없는 케이스**는 기존 휴리스틱(도메인·동사·메모리·맥락·최근 사용) 적용.
3. **새로 자주 충돌하는 케이스 발견 시** → ben에 보고하고 비교 라운드 추가 후 이 맵 업데이트.
4. **Founder가 명시 지정하면** 이 맵 무시.
5. **분기 1회 재검증** 권장 (도구 업데이트로 우열 바뀔 수 있음). 다음 재검증 권장 시점: 2026-07-25.

---

## 보조: 자주 쓰는 30개 단축 매핑

| ben 키워드 | 자동 호출 |
|---|---|
| "페르소나", "타깃 사용자" | ux-researcher 에이전트 |
| "경쟁사", "경쟁 분석" | market-researcher 에이전트 |
| "이 화면 봐줘", "사용성 평가" | gui-critic 에이전트 |
| "이 화면 체계적으로 평가" | gui-critic + frontend-design-audit:evaluate 병행 |
| "문구", "라이팅", "어색" | /ux-write 커맨드 |
| "사업 모델", "비즈니스 모델" | startup-canvas 스킬 |
| "MVP 빠르게", "린 캔버스" | lean-canvas 스킬 |
| "PRD", "기획서" | /write-prd (pm-execution) |
| "북극성", "핵심 지표" | /north-star (pm-marketing-growth) |
| "사전 부검", "리스크" | /pre-mortem (pm-execution) |
| "우선순위 매겨줘" | /prioritize-features (pm-product-discovery) |
| "A/B 테스트 해석" | /analyze-test (pm-data-analytics) |
| "코호트", "리텐션" | /analyze-cohorts (pm-data-analytics) |
| "코드 짜줘", "구현해줘" | Codex 위임 (memory `feedback_codex_delegation_default`) |
| "Figma에서" | figma MCP + figma-use 스킬 |
| "GitHub에서", "PR" | github MCP |
| "배포해줘" | vercel MCP (단, Founder 명시 승인 필요) |

---

## 한계 (정직)

- 5케이스만 비교, 나머지 215개 스킬은 미검증
- 시뮬레이션 기반 (실제 도구 호출 X). 실전 결과는 다를 수 있음
- 평가자(L1)의 한국어 PD 친화 편향 있음
- 분기 재검증 안 하면 무용지물 됨 (도구 업데이트 시)
