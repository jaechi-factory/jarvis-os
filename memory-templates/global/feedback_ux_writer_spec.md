---
name: UX 라이팅 작업 시 spec 파일 필수 로드
description: UX 라이팅·문구·카피 작업 시작 전 반드시 ~/.claude/prompts/ux-writer.md 읽기. 포인터만 읽고 진행 금지
type: feedback
originSessionId: 972c213b-e2f6-476b-887a-856e7b4d7a0c
---
UX 라이팅·문구·카피·copy 작업을 시작하기 전에 **반드시** `~/.claude/prompts/ux-writer.md`를 Read할 것.

**Why:** `reference_ux_writer.md`(포인터)만 읽고 실제 spec 없이 작업하면 — content_type 글자 수 제한, 번역투 사전 14쌍, brand_voice 프로파일, 전환 레버 4종, Self-Critique 6단계, 구체성/일관성/주체 규칙, 규칙 충돌 우선순위 등 핵심 규격을 놓침. 실제로 이런 일이 발생했고 spec 기준 위반 4건이 확인됐음.

**How to apply:**
- 트리거: "라이팅", "문구", "카피", "UX writing", "copy", "어색", "말", "텍스트 교정", `/ux-write`, `/ux-wash`
- 작업 전 첫 번째 행동 = `Read(~/.claude/prompts/ux-writer.md)`
- 포인터 파일(`reference_ux_writer.md`) 로드만으로는 충분하지 않음. 실제 spec 파일을 읽어야 함
- spec을 읽지 않은 상태에서 문구 수정을 제안하거나 코드에 반영하지 말 것
