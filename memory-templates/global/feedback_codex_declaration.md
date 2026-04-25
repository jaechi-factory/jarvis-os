---
name: Codex 선언 의무 — 구현 전 [Claude]/[Codex] 선언 필수
description: 모든 구현 작업 시작 전 반드시 [Claude] 또는 [Codex] 선언. 누락 시 사용자 지적 받음.
type: feedback
originSessionId: 309d72a1-badc-4357-b768-f2121efce5ff
---
모든 구현 작업 시작 전 첫 줄에 반드시 선언하고 진행한다.

```
[Codex] AddPage.tsx + useRecipes.ts 수정 — 다파일 위임
[Claude] handleBack 2줄 외과적 수정 — 예외 해당
```

**Why:** 사용자가 누가 어떤 작업을 했는지 추적할 수 없으면 책임 소재와 작업 범위 파악이 불가능하다. 여러 세션에 걸쳐 반복 지적됨.

**How to apply:**
- 코드 수정/작성 시작 전, 도구 호출 전에 선언 텍스트를 먼저 출력
- **기준은 `feedback_codex_delegation_default.md` 우선 적용**:
  - 파일 편집/생성이 수반되면 → 무조건 **[Codex]**
  - Claude 직접 수정 허용 예외 3가지만: (1) 1파일 1~3줄 외과적 수정 (2) Codex 실패 복구 (3) 사용자 "직접 해" 명시
- 선언 없이 Edit/Write 도구 호출 절대 금지
- Codex 실제 호출(`mcp__codex-cli__codex`) 없이 "[Codex] 위임" 표기 금지
