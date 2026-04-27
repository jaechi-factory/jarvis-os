---
name: PM Skills 마켓플레이스 통합 전략
description: phuryn/pm-skills 65 skills + 36 commands를 기존 L2/L3 체계에 편입. 3-Layer 운영 모델 · 트리거 규칙 · 프로젝트별 적용 가이드. 2026-04-21 L1 자율 적용.
type: reference
originSessionId: c515af7f-a734-403d-943c-4c018588ccbf
---
# PM Skills 통합 전략 (2026-04-21)

phuryn/pm-skills 설치(8 플러그인 · 65 skills · 36 commands) 후 기존 L1→L2→L3 체계와의 조율 방식.

---

## 1. 3-Layer 운영 모델

**기본 원칙**: PM Skills가 기존 23 L3 에이전트를 대체하지 않고 **보완**. 겹치는 영역은 병행, 고유 영역은 편입.

### Layer A — AGENTS_SYSTEM.md 일급 트리거 편입 (10개)

`AGENTS_SYSTEM.md` 섹션 4 "PM Skills 커맨드 자동 매칭" 테이블에 박힘. L1이 한국어 트리거 감지 → 자동 호출.

| 커맨드 | 한국어 트리거 | 소속 (병행 디렉터) |
|---|---|---|
| `/discover` | 새 아이디어, 초기 탐색 | product-director |
| `/write-prd` | PRD, 스펙, 기획서 | pm-director |
| `/north-star` | 북극성, NSM, 핵심 지표 | growth-director |
| `prioritize-features` | 기능 우선순위, 백로그 정리 | pm-director |
| `/triage-requests` | 이슈 분류, 요청 트리아지 | pm-director |
| `/pre-mortem` | 사전 부검, 런칭 리스크 | qa-director |
| `/stakeholder-map` | 이해관계자, 승인 루트 | pm-director |
| `/write-stories` | 유저 스토리, 백로그 아이템 | engineering-director |
| `/analyze-test` | A/B 테스트 해석 | product-director |
| `/analyze-cohorts` | 코호트, 리텐션 | product-director |

### Layer B — 병행 호출 (기존 L3 + PM Skill 조합)

특정 요청에서 **한국 시장 맥락(L3 에이전트)** + **글로벌 프레임워크(PM Skill)**를 같이 돌려 교차 검증.

| 요청 성격 | L3 에이전트 | 병행 PM Skill/Command | 이유 |
|---|---|---|---|
| 수익화 방향 | monetization-advisor | `/pricing`, `monetization-strategy` | <owner workplace>·토스 맥락 + Price Elasticity 프레임워크 |
| 시장/경쟁 분석 | market-researcher | `/market-scan`, `/competitive-analysis` | 한국 시장 + SWOT/PESTLE/5-Forces/Ansoff |
| 제품 전략 | product-strategist | `/strategy`, `/business-model` | 프로젝트 메모리 + 9섹션 Canvas |
| 그로스 | growth-marketer, seo-specialist | `/plan-launch`, `/growth-strategy` | 한국 채널 + 그로스 루프 프레임워크 |
| 배틀카드 | — | `/battlecard` | PM Skill 고유 |

### Layer C — Description 자동 로드 (55개 나머지)

Claude의 skill 시스템이 description 매칭으로 알아서 호출. L1이 명시적으로 라우팅 안 함.

**대표 예시**: `opportunity-solution-tree` (Teresa Torres OST), `lean-canvas`, `swot-analysis`, `porters-five-forces`, `ansoff-matrix`, `jtbd`류, `persona`류, `roadmap`류, `sprint-plan`, `retro`, `release-notes`, `meeting-notes`, `value-proposition` 등.

---

## 2. 트리거 충돌 해소 원칙

같은 요청에 L2 디렉터 + PM Skill 둘 다 걸릴 때:

1. **PM Skill 커맨드가 있으면 먼저 실행** (프레임워크 기반 구조화 산출물)
2. **병행 L3 에이전트 호출**로 한국 시장 맥락 보강
3. **L1이 두 결과 종합** 후 {{USER_NAME}} 보고 (5블록 리포트 의무)
4. **모호할 때**: L1이 해석·이유 명시 후 선택. 자동 판단 금지 규칙은 유지

### 배타 키워드 가이드

비슷해 보이는 한국어 단어를 서로 겹치지 않게:

- "새 아이디어" → `/discover` (신규 탐색 전용)
- "스펙 쓰자" → `/write-prd` (문서화 단계)
- "사업 전략" → product-strategist + `/strategy` (전략 수립)
- "기획" 단독 → 앞뒤 문맥 보고 셋 중 하나. 불명확하면 L1이 되물음

---

## 3. 프로젝트별 즉시 적용 가이드

현재 활성 프로젝트에 PM Skills 어떻게 쓸지:

### [본업] (<owner workplace> 본업)
- `/analyze-feedback`: 지표 스냅샷 58 CSV · 취소사유 데이터 해석
- `/analyze-test`: 결제스크린 교차실험 결과 해석
- `/analyze-cohorts`: 주문전환율 4/13 26.8% 코호트별 분해
- `sentiment-analysis` skill: 사용자 피드백 테마 추출

### [예시 프로젝트 C]
- 🔴 최우선: `/north-star` — "돈 버는 것" 원칙에 맞춰 NSM 재정의
- `/pricing`: 수익 모델 설계
- `/plan-launch`: 콘솔 등록 직전 런칭 체크
- `/pre-mortem`: 런칭 전 리스크 분류

### 하루말씀
- `/pre-mortem`: 365개 콘텐츠 전략 확정 후 실패 시나리오 점검
- `/plan-launch`: 앱인토스 런칭 GTM

### [예시 프로젝트 B]
- NSM 이미 있음(주간 외부링크 클릭) → `opportunity-solution-tree`로 솔루션 분기
- `/analyze-cohorts`: 주말 이용 패턴 코호트 분석

### [예시 프로젝트 F]
- `/triage-requests`: 36개 문제 A/B/C급 분류를 프레임워크로 재검증
- `prioritize-features`: Impact × Effort × Risk 매트릭스 적용

### [예시 프로젝트 A]
- DetailPage TIER3만 남음 → PM Skills 적용 가치 낮음. 기존 체계로 충분

---

## 4. 메타 규칙

- **{{USER_NAME}}은 슬래시 커맨드를 외울 필요 없음**. L1이 한국어 듣고 자동 라우팅
- **L1이 커맨드 호출 시** 프로젝트 메모리 먼저 Read → 커맨드 `$ARGUMENTS`에 맥락 주입 (예: [본업] 수수료 2.2%, 토스 앱인토스 제약 등)
- **PM Skills 결과는 글로벌 프레임워크 기반**이라 한국 시장·제품 특수 맥락을 모름 → L1이 반드시 현지화 반영 후 보고
- **새 PM Skill 유용성 발견 시** 이 메모리 + AGENTS_SYSTEM.md 섹션 4 트리거 테이블에 추가
- **안 쓰는 스킬 발견 시** 2주 사용 후 Layer A에서 제거, description 자동 로드로 강등

---

## 5. 설치 상태

- 마켓플레이스: `phuryn/pm-skills` (user settings 등록)
- 캐시 위치: `~/.claude/plugins/cache/pm-skills/`
- 설치 플러그인 8개: pm-toolkit, pm-product-strategy, pm-product-discovery, pm-market-research, pm-data-analytics, pm-marketing-growth, pm-go-to-market, pm-execution (각 1.0.1)
- 기반 인물: Teresa Torres, Marty Cagan, Alberto Savoia, Roger Martin, Ash Maurya, Sean Ellis 등 (README 참조)
