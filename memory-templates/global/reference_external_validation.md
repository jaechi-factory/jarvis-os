---
name: 외부 평판 검증 v1.1 (External Validation)
description: 8 마켓플레이스·26 플러그인 GitHub·커뮤니티 평판 조사 (2026-04-25). 우리 매트릭스(한국 풀스택 PD 케이스 비교) vs 외부 보편 인기도 비교. 리밸런싱 권고 포함 (강화·추가·강등 후보). v1.1 (2026-04-25): Profile v2.0 풀스택 올라운더 반영, 평가 기준 갱신, 영문 도구 강등 권고 완화
type: reference
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 외부 평판 검증 v1.0

**작성**: 2026-04-25
**근거**: GitHub API 8개 마켓플레이스 + 핵심 외부 후보 6개 직접 조회, 커뮤니티 큐레이션 리스트 4종(awesome-claude-code/awesome-claude-plugins/Composio/quemsah) 메타 분석
**범위**: 우리가 깐 8 마켓플레이스 정합성 + 안 깐 외부 인기 후보 톱 5
**데이터 시점**: 2026-04-25 (GitHub API 라이브)

---

## Why

218개 스킬·26개 플러그인을 한국 풀스택 PD 케이스 비교로 1순위 박았으나, 외부 평판(GitHub stars·활성도·커뮤니티 추천)과 정합성을 검증해 "안 깐 더 좋은 도구"가 있는지 확인하기 위함. 외부 평판 ≠ 한국 풀스택 PD 적합도. 매트릭스가 1순위 SSOT, 외부는 보강 자료.

---

## 1. 마켓플레이스 평판 표 (8개 + 우리가 깐 플러그인 1개 추가)

| # | 마켓플레이스 / 플러그인 | GitHub Repo | ⭐ Stars | 🍴 Forks | 🐛 Issues | 📅 Last Push | 활성 | 종합 |
|---|---|---|---:|---:|---:|---|:---:|---|
| 0 | **anthropics/claude-code** (모체) | anthropics/claude-code | 117,746 | 19,605 | 10,622 | 2026-04-25 | ✅ | S+ 공식 본진 |
| 1 | **claude-plugins-official** | anthropics/claude-plugins-official | 17,777 | 2,130 | 573 | 2026-04-24 | ✅ | A+ 공식 디렉토리 |
| 2 | **superpowers** (obra) | obra/superpowers | 167,077 | 14,695 | 326 | 2026-04-24 | ✅ | **S** 외부 1위 (별 기준 1위) |
| 3 | **claude-mem** (thedotmack) | thedotmack/claude-mem | 67,162 | 5,712 | 107 | 2026-04-25 | ✅ | A 메모리 카테고리 톱 |
| 4 | **ui-ux-pro-max-skill** | NextLevelBuilder/ui-ux-pro-max-skill | 70,220 | 7,189 | 122 | 2026-04-03 | ✅ | A 디자인 카테고리 외부 1위 |
| 5 | **context7** | upstash/context7 | 53,682 | 2,540 | 130 | 2026-04-24 | ✅ | A 문서 조회 표준 |
| 6 | **compound-engineering-plugin** | EveryInc/compound-engineering-plugin | 15,491 | 1,197 | 58 | 2026-04-25 | ✅ | A- 36 스킬·51 에이전트 풀 |
| 7 | **pm-skills** (phuryn) | phuryn/pm-skills | 10,613 | 1,229 | 12 | 2026-04-22 | ✅ | A- PM 카테고리 외부 1위 |
| 8 | **designer-skills** (Owl-Listener) | Owl-Listener/designer-skills | 796 | 154 | 8 | 2026-03-15 | 🟡 | C+ 분량·인지도 약함 |
| 9 | **frontend-design-audit** (mistyhx) | mistyhx/frontend-design-audit | 40 | 4 | 0 | 2026-03-11 | 🟡 | D 거의 무명 (1인 프로젝트) |

**활성 기준**: 🟢 최근 1개월 / 🟡 1~3개월 / 🔴 3개월+

**주요 발견**:
- ben이 깐 8개 중 7개는 **외부 평판 강세**. 단 2개(designer-skills, frontend-design-audit)가 약함
- **superpowers 167k**는 압도적 외부 1위 — 우리도 이미 설치+적극 사용 중 → 정합
- **claude-mem 67k**, **ui-ux-pro-max 70k** 둘 다 외부 톱 — 우리도 설치 → 정합

---

## 2. 핵심 플러그인 평판 (카테고리별 톱)

### 디자인 카테고리

| 플러그인 | ⭐ | 우리 매트릭스 위치 | 외부 평판 |
|---|---:|---|---|
| ui-ux-pro-max-skill | 70,220 | E-23 비주얼 디자이너 (탐색 모드) | "world's most popular community design skill" 평가 |
| frontend-design (anthropic 공식) | 117,746 (모체 일부) | 매트릭스 미매핑 | **277,000+ installs** (외부 명시 사용량 1위 디자인) |
| designer-skills (Owl-Listener) | 796 | 8개 카테고리 풀 (E-22~E-26) | 별 낮음, **but** UI 카테고리 풀 커버리지로 유효 |
| frontend-design-audit (mistyhx) | 40 | H-43 접근성 QA 보조 | 평판 없음 (1인 무명 프로젝트) |
| **tweakcn** (jnsahaj) | 9,752 | **미설치** | shadcn 테마 표준, 디자인 코드 결과물 단계 |

### PM·기획 카테고리

| 플러그인 | ⭐ | 우리 매트릭스 위치 | 외부 평판 |
|---|---:|---|---|
| pm-skills (phuryn) | 10,613 | A·C·F 카테고리 핵심 (write-prd, prioritize-features 등) | PM 카테고리 외부 1위, 100+ skill 풀 |
| **Product-Manager-Skills** (deanpeters) | 3,751 | **미설치** | "battle-tested" 평가, Senior PM 30+ frameworks |
| **awesome-claude-code** (hesreallyhim) | 40,890 | 큐레이션 (마켓플레이스 X) | 메타-디렉토리 톱, 추가 도구 발굴용 |

### 메모리·세션 카테고리

| 플러그인 | ⭐ | 우리 매트릭스 위치 | 외부 평판 |
|---|---:|---|---|
| claude-mem | 67,162 | 매트릭스 미매핑 (자동 hook으로 백그라운드 동작) | 메모리 카테고리 외부 1위 |
| superpowers | 167,077 | 메타 워크플로우 스킬 (brainstorm/TDD/git-worktrees 등) | **외부 종합 1위 별 기준** |

### 라이브러리 문서 조회

| 플러그인 | ⭐ | 우리 매트릭스 위치 | 외부 평판 |
|---|---:|---|---|
| context7 | 53,682 | G-30~G-34 보조 (라이브러리 docs) | 외부 표준 도구 |

### 개발 워크플로우

| 플러그인 | ⭐ | 우리 매트릭스 위치 | 외부 평판 |
|---|---:|---|---|
| compound-engineering | 15,491 | H QA 풀 (28 review + 7 doc-review) | 외부 인지도 중상, 실용성 강함 |
| **feature-dev** (Anthropic 공식) | (claude-code 117k 일부) | **미사용** | "최다 89,000 installs" 외부 1위 워크플로우 |
| **ship** (PR 자동화) | (커뮤니티) | **미사용** | PR commit→prod 풀 파이프라인 |

---

## 3. 동일 카테고리 외부 대안 후보 (우리가 안 깐 인기 도구)

### 디자인 결과물 폴리싱

#### 🆕 **tweakcn** (9,752 stars, jnsahaj/tweakcn)
- **용도**: shadcn/ui 컴포넌트 비주얼 테마 에디터 (코드 NO)
- **우리와 차이**: ui-ux-pro-max는 시안/팔레트 탐색, tweakcn은 **코드로 떨어진 shadcn 결과물 다듬기**
- **한국 풀스택 PD 적합도**: 중상 (shadcn 사용 시), 영문 UI지만 비주얼 직관
- **L1 추천도**: 🟡 후보 보강 — [예시 프로젝트 A]·my-mbti처럼 shadcn 쓰는 프로젝트 한정 가치 있음. 한국 PD 톤 무관.

### 메타 워크플로우

#### 🆕 **feature-dev** (Anthropic 공식, 89k+ installs)
- **용도**: 7단계 (요구사항→탐색→아키텍처→구현→테스트→리뷰→문서) 자동 워크플로우
- **우리와 차이**: 우리는 planner 에이전트 + Codex 위임으로 비슷한 흐름 수동 운영. feature-dev는 한 커맨드로 자동
- **한국 풀스택 PD 적합도**: 중 (영문 기본, but 결과물은 우리 메모리 룰로 한국화 가능)
- **L1 추천도**: 🟢 **강력 추천** — claude-plugins-official 마켓플레이스에 이미 등록됨, 기능 1개 추가 시 즉시 가치. **추가 비용 0**

#### 🆕 **ship** (PR commit→prod 풀 파이프라인)
- **용도**: lint→test→review→prod 배포 자동화
- **우리와 차이**: 우리는 vercel MCP + 수동 단계. ship은 풀 자동
- **한국 풀스택 PD 적합도**: 중하 (배포는 ben Founder 명시 승인 필요 — 자동화 효과 제한)
- **L1 추천도**: 🔴 **비추** — Founder 명시 승인 게이트 룰 위반 위험. 기존 워크플로우 유지

### PM 보강

#### 🆕 **Product-Manager-Skills** (deanpeters, 3,751 stars)
- **용도**: Senior PM 30+ frameworks, 디스커버리/전략/딜리버리/SaaS 메트릭/PM 커리어 코칭/AI 제품 craft
- **우리와 차이**: phuryn pm-skills는 65 skills + 36 commands (광범위·실무), deanpeters는 시니어 PM 의사결정 프레임워크 깊이
- **한국 풀스택 PD 적합도**: 중상 (영문이나 프레임워크 자체는 글로벌 표준)
- **L1 추천도**: 🟢 **추가 검토** — pm-skills와 보완적. ben이 사업 방향 결정 같은 시니어 의사결정 자주 하면 가치 큼

#### 🆕 **alirezarezvani/claude-skills** (12,646 stars, 232+ skills)
- **용도**: 232 스킬 풀 (engineering·marketing·product·compliance·C-level)
- **우리와 차이**: 광범위 + Cursor·Codex 호환 강조
- **한국 풀스택 PD 적합도**: 미확인 (스킬 단위 품질 편차 우려)
- **L1 추천도**: 🟡 **탐색만** — 풀 사이즈는 매력적이나 품질 편차 큼. 핫한 것 1~2개만 cherry-pick 권고. 마켓플레이스 통째 설치는 비추

### 메타-디렉토리 (참조용)

#### 🆕 **awesome-claude-code** (hesreallyhim, 40,890 stars)
- **용도**: 큐레이션 리스트 (스킬·훅·슬래시 커맨드·에이전트·앱·플러그인)
- **L1 추천도**: 🟢 **북마크** — 분기별 1회 훑어 신규 도구 발굴. 설치 X, 참고만

---

## 4. 매트릭스 정합성 분석

### 정합 여부 (44 직군 × 핵심 도구 매핑 vs 외부 평판)

| 매트릭스 1순위 | 외부 평판 | 정합? | 비고 |
|---|---|:---:|---|
| ux-researcher 에이전트 (B-7) | 자체 한국어 에이전트, 외부 평판 N/A | ✅ | 한국 풀스택 PD 친화도 우위로 채택 (외부 비교 불가) |
| market-researcher 에이전트 (A-2) | 동일 | ✅ | 동일 |
| gui-critic 에이전트 (B-11, E-22 보조) | 동일 | ✅ | 동일 |
| /ux-write 커맨드 (F-27, H-42) | 동일 (한국어 SSOT) | ✅ | 한국어 매트릭스 기반 — 외부 대안 없음 |
| startup-canvas 스킬 (A-1) | pm-skills (phuryn) 10.6k | ✅ | 매트릭스·외부 모두 1순위 |
| pm-execution:create-prd (C-12) | pm-skills (phuryn) 10.6k | ✅ | 정합 |
| ui-ux-pro-max-skill (E-23 탐색) | 70.2k 외부 1위 | ✅ | **외부·매트릭스 모두 디자인 톱** |
| compound-engineering review/* (H QA) | 15.5k, 외부 인지도 중상 | ✅ | 정합 |
| context7 MCP (G-30~G-34 보조) | 53.7k 외부 표준 | ✅ | 정합 |
| superpowers 스킬 (메타 워크플로우) | 167k 외부 종합 1위 | ✅ | 정합 |
| claude-mem (자동 메모리) | 67k 메모리 1위 | ✅ | 정합 |
| designer-skills (UX 리서치/디자인 풀) | 796 별 약함 | 🟡 **v1.1 정합으로 상향** | v1.0: 영문 풀 무리. **v1.1**: Profile v2.0 풀스택, 영문 부담 적음. 카테고리 풀 커버리지로 유지·강등 권고 철회 |
| frontend-design-audit (H-43 보조) | 40 별 사실상 무명 | 🟡 **v1.1 완화** | v1.0: 강등 권고. **v1.1**: Profile v2.0 풀스택, 영문 평가지표 직독 가능 → 보조 유지하되 실호출 빈도 추적. 더 나은 대안 발굴 시만 교체 |

### 정합률

- **명시 매핑 13개 중 11개 정합 (85%)**
- **불일치 2건 (v1.1 갱신)**: designer-skills, frontend-design-audit 모두 강등 권고 완화. Profile v2.0 풀스택으로 영문 부담 적음, 매트릭스 매핑 유지
- **외부 1위인데 우리 매핑 누락**: feature-dev (워크플로우), tweakcn (디자인 결과물), Product-Manager-Skills (시니어 PM) → 강화 검토

---

## 5. 리밸런싱 권고 표

### 🟢 유지 (외부 평판·매트릭스 일치, 변경 없음)

| 도구 | 근거 |
|---|---|
| superpowers 스킬 | 167k 외부 1위, 우리도 적극 사용 |
| claude-mem | 67k 메모리 1위, 자동 hook 동작 |
| ui-ux-pro-max-skill | 70k 디자인 외부 1위, 매트릭스 E-23 탐색 모드 채택 |
| context7 | 53.7k 표준 라이브러리 docs |
| pm-skills (phuryn) | 10.6k PM 1위, 매트릭스 A·C·F 핵심 |
| compound-engineering | 15.5k QA 풀 핵심 |
| 자체 에이전트 (ux-researcher/market-researcher/gui-critic/ux-writer 등) | 한국어 친화도로 외부 영문 대안 압도 — 매트릭스 1순위 유지 |

### 🟢 강화 후보 (외부 1위인데 매트릭스 매핑 누락 → 추가 매핑 권고)

| 도구 | 권고 매핑 위치 | 근거 | 트레이드오프 | L1 추천 |
|---|---|---|---|---|
| **feature-dev** (Anthropic 공식, 89k+ installs) | 신설 트리거 "기능 1개 풀스택" | 7단계 자동, 비용 0 | 영문 결과물 → 한국화 후처리 필요 | ✅ **추가 매핑 권고** — `feature-dev`를 PM Skills 트리거 표에 신규 행으로 박음. 기능 1개 = 자동 호출 |
| **Product-Manager-Skills** (deanpeters, 3.7k) | A-1 사업기획 보조, A-5 수익모델 보조 | 시니어 PM 의사결정 프레임워크 30+개 | pm-skills와 일부 중복 | 🟡 **분기별 cherry-pick** — 마켓플레이스 통째 설치 X, 핫한 스킬 1~2개만 추출 검토 |

### 🟢 추가 후보 (안 깐 외부 인기 도구, 신규 설치 검토)

| 도구 | ⭐ | 카테고리 | 근거 | L1 추천 |
|---|---:|---|---|---|
| **tweakcn** (jnsahaj) | 9,752 | 디자인 결과물 폴리싱 | shadcn 테마 비주얼 에디터, [예시 프로젝트 A]/my-mbti에 즉시 적용 가능 | 🟡 **shadcn 프로젝트 한정 검토** — 일반 PD 워크플로우 외 |
| **awesome-claude-code** (hesreallyhim) | 40,890 | 메타 디렉토리 | 신규 도구 분기별 발굴용 | ✅ **북마크** — 설치 X, 분기 재검증 시 참조 |
| **alirezarezvani/claude-skills** | 12,646 | 232 스킬 풀 | 광범위 풀, 핫한 것만 추출 | 🟡 **탐색만** — 통째 설치 비추, 1~2개 cherry-pick |
| **awesome-claude-plugins** (ComposioHQ) | 1,483 | 메타 디렉토리 | 플러그인 큐레이션 | 🟢 북마크 |
| **superpowers-marketplace** (obra) | 미조회 | superpowers 확장 풀 | 우리 기존 superpowers와 페어링 | 🟡 **검토** — 본진 superpowers 사용도 고려 시 가치 |

### 🔴 강등·정리 후보 (외부 평판 약함 + 매트릭스 1순위 아님)

| 도구 | 현 위치 | 외부 평판 | 권고 |
|---|---|---|---|
| **frontend-design-audit** (mistyhx) | H-43 접근성 QA 보조 | 40 stars, 0 issues, 무명 | 🟡 **v1.1 완화 — 강등 권고 철회** | Profile v2.0 풀스택 영문 부담 적음. 보조 위치 유지, 실사용 빈도 추적 후 더 나은 대안 발굴 시만 교체 |
| **designer-skills** (Owl-Listener) | E-22~E-26 풀 (UI/디자인 8 카테고리) | 796 stars, 영문, 분량 짧음 | 🟡 **유지하되 사용 빈도 추적** — 자체 ui-designer/gui-critic 에이전트와 비교해 실호출률 낮으면 차후 정리. 현재는 카테고리 풀 커버리지 가치로 유지 |

---

## 6. 한계 (정직)

- **GitHub stars ≠ 사용 품질**: 별이 많아도 한국 풀스택 PD 워크플로우와 미스매치 가능 (예: feature-dev 영문 결과물)
- **API 데이터 시점**: 2026-04-25 기준 라이브 GitHub API. 분기 후 변동 가능 (다음 재검증: 2026-07-25)
- **심층 검증 미실시**: 외부 후보(tweakcn·feature-dev·Product-Manager-Skills) 실호출 비교 라운드 미진행. 실전 적용 후 재평가 권장
- **한국 PD 적합도 평가는 L1 휴리스틱**: 외부 별 기준 + L1 한국어 친화 판단. 객관 점수 X
- **Composio·awesome-claude-code 큐레이션 의존**: 큐레이션 자체에 편향 가능 (영어권 개발자 중심)
- **218개 스킬 단위 검증 X**: 마켓플레이스·핵심 플러그인 수준만. 스킬 1개씩 외부 평판 조사는 비용 대비 효과 낮음 → 수행 안 함
- **API 호출 비용**: GitHub API 인증 없음 (시간당 60 요청). 8 마켓플레이스 + 핵심 후보 6개 = 14 호출, 여유 있음. 추가 후보 발굴은 다음 분기로

---

## 7. 결론 한 줄

**우리 매트릭스 정합률 85% (11/13). v1.1 갱신: Profile v2.0 풀스택 올라운더 반영 → 강등 권고 2건 모두 완화(designer-skills + frontend-design-audit, 실호출 빈도 추적으로 전환). 강화 매핑 1건(feature-dev)만 즉시 반영 권고. ben이 깐 8 마켓플레이스는 대체로 외부 톱과 정합 — 한국 풀스택 PD 매트릭스 SSOT 유지.**

---

## 8. v1.1 갱신 노트 (2026-04-25)

- **평가 기준 정정**: "한국 PD 친화도" → "한국 풀스택 PD 친화도" (Profile v2.0 반영)
- **영문 도구 강등 권고 완화**: ben이 코드·평가지표 직독 가능, 영문 부담 적음
  - designer-skills: 강등 후보 → 정합으로 상향 (카테고리 풀 커버리지 유지)
  - frontend-design-audit: 강등 권고 → 보조 유지 (실호출 빈도 추적 후 재평가)
- **pm-market-research 영문 IR 톤**: 본문에 명시 강등 권고 없었음 — 별도 정정 불필요. Profile v2.0 적용으로 자동 재고 가능
- **다음 재검증**: 2026-07-25 (분기), 또는 ben 픽 결과 반영 시
