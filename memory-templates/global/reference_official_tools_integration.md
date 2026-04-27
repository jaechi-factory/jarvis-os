---
name: 공식 도구 통합 룰 v1.0 (Official Tools Integration)
description: claude-plugins-official 마켓플레이스 6개 도구(code-review, context7, figma, frontend-design, skill-creator, superpowers) 자동 트리거 매핑. {{USER_NAME}} 지시 "공식 도구는 모두 잘 쓰일 수 있도록" 반영. 외부 평판 검증 완료 (anthropics/claude-plugins-official 17k stars)
type: reference
originSessionId: bb874fd4-6435-488a-84fa-378c95117d29
---
# 공식 도구 통합 룰 v1.0

**작성**: 2026-04-25
**근거**: {{USER_NAME}} 지시 "Anthropic 공식 도구는 모두 잘 쓰일 수 있도록 만들어"
**SSOT 정합**: `reference_external_validation.md` (정합률 85%) + `feedback_role_tool_matrix.md` v1.0

---

## Why

claude-plugins-official 6개 도구가 깔려 있는데 활용도 차이가 큼. code-review·superpowers는 잘 쓰지만 skill-creator·context7은 거의 안 씀. {{USER_NAME}}이 "공식이라 품질 검증된 거니까 모두 활용하라"고 명시 → 자동 트리거 룰 6개 박음.

## How to apply

{{USER_NAME}} 메시지에서 트리거 키워드 매칭되면 해당 도구 자동 호출. 매트릭스 1순위와 충돌 시 매트릭스 우선 (단, 공식 도구가 보조 위치로 항상 페어링).

---

## 트리거 매핑 (6 도구)

### 1. code-review
**트리거**: "코드 리뷰", "PR 검토", "변경사항 봐줘", "이거 봐줘", "리뷰해줘"

**자동 호출 시점**:
- 구현 완료 후 (이미 메모리 룰 `feedback_qa_agent_required`)
- PR 생성 직전 (필수 게이트)
- 배포 전 풀세트 일부

**페어링**: `code-reviewer` 에이전트 + 본 도구. 같이 호출 패턴.

---

### 2. context7 (MCP + 스킬)
**트리거**:
- 라이브러리·프레임워크 이름 + "사용법", "API", "어떻게 쓰지", "최신", "문서"
- 예: "React의 useTransition", "Next.js App Router 최신 패턴", "Tailwind CSS 4 마이그레이션"
- "최신", "공식 문서", "버전 확인"

**자동 호출 시점**:
- 코드 작성 **전** (라이브러리 선택·API 사용법 확인)
- 라이브러리 업그레이드 검토 시
- 모르는 API 등장 시

**금지 케이스**: 일반 정보 검색, 비즈니스 의사결정 — WebSearch 사용

**보강**: 메모리 `feedback_codex_delegation_default` 룰의 "Codex 위임 전 context7로 권장 패턴 확인" 단계로 통합.

---

### 3. figma (MCP + 스킬)
**트리거**:
- "Figma", "figma.com URL"
- "이 디자인", "시안 가져와", "디자인 → 코드"
- Figma URL 직접 첨부 시 즉시 발동

**자동 호출 시점**:
- Figma URL 받으면 **즉시** (다른 작업보다 우선)
- 디자인 작업 시작 시 figma-use 스킬 강제 우선

**페어링**: figma MCP + figma-use 스킬 + ui-designer 에이전트 (3중 콤보)

**메모리 정합**: `reference_figma_mcp_access` (get_design_context 실패 시 우회 방법)

---

### 4. frontend-design
**트리거**:
- "이 디자인 코드로", "프론트엔드 만들어", "UI 컴포넌트 짜줘"
- "React 컴포넌트", "Next.js 페이지", "Vue 컴포넌트"
- 코드 프로토타입 단계

**자동 호출 시점**:
- 디자인 → 코드 변환 단계 (E-25 프로토타이퍼 1순위)
- shadcn·MUI·Chakra 등 UI 라이브러리 사용 시 가이드

**보강**: figma 도구로 디자인 가져온 후 frontend-design으로 코드화하는 페어 패턴.

**Codex 정합**: 본 도구는 "패턴 가이드", 실제 코드 작성은 Codex 위임 (메모리 룰).

---

### 5. skill-creator
**트리거**:
- "스킬 만들어", "이 워크플로 자동화", "커스텀 스킬"
- "이거 자주 하니까 자동화", "이걸 트리거로"

**자동 호출 시점**:
- 같은 작업 3회 이상 반복 감지 시 → "스킬로 만들까요?" 제안
- {{USER_NAME}}이 자동화 명시 요청 시

**활용 빈도**: 가끔 (단발성). 단, 자동화 가치 높을 때 적극 활용.

---

### 6. superpowers (14개 메타 워크플로우)
가장 풍부한 도구. 트리거 키워드별 매핑:

| 트리거 키워드 | 자동 호출 스킬 |
|---|---|
| "브레인스톰", "막연함", "탐색 단계" | `brainstorming` |
| "계획 짜자", "다단계", "어떻게 갈까" | `writing-plans` |
| "이 계획 실행", "단계별 진행" | `executing-plans` |
| "테스트 먼저", "TDD" | `test-driven-development` |
| "디버깅", "안 됨", "왜 이럴까" | `systematic-debugging` |
| "검증 끝났나", "다 됐나" | `verification-before-completion` |
| "코드 리뷰 부탁", "리뷰 받아야" | `requesting-code-review` |
| "리뷰 받았는데", "피드백 왔어" | `receiving-code-review` |
| "여러 작업 동시", "병렬로" | `dispatching-parallel-agents` |
| "브랜치 마무리", "PR 보낼 때" | `finishing-a-development-branch` |
| "워크트리", "독립 작업" | `using-git-worktrees` |
| "스킬 만들 때", "스킬 작성" | `writing-skills` |

**자동 호출 패턴**: 새 기능 작업 시 거의 자동 — `brainstorming` → `writing-plans` → `executing-plans` → `verification-before-completion` 사이클.

---

## AGENTS_SYSTEM.md 섹션 4 통합

기존 PM Skills 트리거 표(11행)에 "공식 도구 트리거 6도구"를 별도 섹션으로 추가 권장. 다만 이 메모리 자체가 SSOT라 AGENTS_SYSTEM.md엔 참조 한 줄만 추가:

```
### 공식 도구 자동 트리거 (2026-04-25 편입)
상세: `memory/global/reference_official_tools_integration.md` 참조
```

---

## 활용도 향상 효과 (예상)

| 도구 | 이전 | 이후 |
|---|---|---|
| code-review | 🔥 자주 | 🔥 자주 (변화 없음, 이미 활용도 높음) |
| context7 | 🟡 가끔 | 🔥 자주 (코드 작성 전 단계로 격상) |
| figma | 🟡 가끔 | 🔥 자주 (Figma URL 즉시 발동) |
| frontend-design | 🟡 가끔 | 🟡 가끔 (코드 프로토 단계 명확화) |
| skill-creator | ⚪ 거의 안 씀 | 🟡 가끔 (반복 감지 자동 제안) |
| superpowers | 🔥 자주 | 🔥 자주 (트리거 표 명문화로 누락 방지) |

**예상 결과**: context7·figma 활용 빈도 상승. skill-creator는 자동 제안으로 편입.

---

## 한계 (정직)

- 자동 호출은 트리거 키워드 매칭에 의존. {{USER_NAME}}이 다른 표현 쓰면 미발동 가능 (예: "Figma" 대신 "그 디자인 화면")
- 트리거 표가 {{USER_NAME}} 일상 어휘와 다를 수 있음. 사용 누적 후 보강 필요
- skill-creator 자동 제안은 사용자 부담 (제안만으로도 거슬릴 수 있음). 신중히
- frontend-design은 패턴 가이드용. 실제 코드 작성은 Codex 위임 룰 우선
- feature-dev는 우리 마켓에 없음 (이전 외부 평판 sub-agent 보고 일부 부정확). 6개 한정
- 분기 재검증: 2026-07-25 — 새 공식 도구 추가됐는지 확인
