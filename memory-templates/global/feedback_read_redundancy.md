---
name: 파일 재Read 금지 규칙 (내가 직접 수정한 파일 한정)
description: Edit/Write 후 시스템이 'file state is current' 알리면 재Read 금지. 외부(Codex/에이전트/사용자)가 만진 뒤에만 재Read. 큰 파일 반복 Read 토큰 낭비 방지
type: feedback
originSessionId: b0c4a593-7c46-4ee0-94c8-fb4e0aa3a54a
---

Claude가 직접 Edit/Write로 수정한 파일은 **재Read 금지**. 시스템이 `file state is current in your context — no need to Read it back` 메시지로 파일 상태를 추적해 줌. 그 뒤 Edit이 또 필요하면 해당 line 근처만 `Read offset=<N> limit=<M>`로 부분 읽기.

**재Read가 필요한 경우:**
- Codex MCP 호출 후 돌아올 때 (외부 도구가 파일 수정)
- Agent(subagent) 실행 후 돌아올 때
- 사용자가 수동 편집을 알려줬을 때
- 빌드/테스트 실패 등으로 파일이 다른 프로세스에 의해 바뀌었을 수 있을 때
- `git checkout HEAD -- <path>` 등 git 명령으로 원복한 뒤

**Why:** 2026-04-18 [예시 프로젝트 A] 세션에서 App.tsx(~600줄)을 한 세션에 여러 번 반복 Read. Edit 전 Read 규칙을 과하게 해석해서 매번 전체를 다시 읽음. 시스템이 파일 상태를 추적해주는데도 습관적으로 재Read → 큰 파일일수록 토큰 비용 폭증.

**How to apply:**
- Edit/Write 직후 Edit 추가 필요 시: 재Read 없이 바로 Edit. 새 old_string이 이전 Edit 결과와 충돌하지 않는지만 정신 차리고 확인
- 부분 탐색이 필요하면: Grep으로 줄 번호 찾고 → `Read offset limit`으로 필요한 영역(±20줄)만
- 전체 재Read는 Codex/에이전트/git 명령 뒤에만 정당화됨
- 판단 애매하면 부분 Read가 기본값. 전체 Read는 "구조 파악이 처음" 또는 "외부 수정 이후"일 때만
