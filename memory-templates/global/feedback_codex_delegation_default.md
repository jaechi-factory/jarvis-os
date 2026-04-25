---
name: Codex 우선 위임 — 토큰 리밸런싱
description: 기계적·반복적·다파일 작업은 기본 Codex 위임. Claude는 판단·리뷰만.
type: feedback
originSessionId: 064d95cf-eb75-4881-9de4-c51c4be9b9b9
---
**파일을 건드리는 모든 작업은 Codex 기본값. 예외 없음.** Claude는 판단·설계·리뷰만.

**Why:** 2026-04-13 최초 요청. 2026-04-15 재강조 — "이런 사소한 처리들도 Codex한테 위임할 수 있나? 새로 만드는 세션, 모든 프로젝트에 적용하고 싶어." 파일 수·줄 수·난이도 관계없이 Codex 위임이 기본값. 오늘 Claude가 직접 수정한 것(proxy-image.js 생성, extract.js 수정)은 규칙 위반이었음 — 이후엔 Codex 위임 철저히.

**How to apply:**
- 파일 편집/생성이 수반되면 → 무조건 **Codex** (버튼 텍스트 1글자 바꾸는 것도 포함)
- Claude 직접 파일 수정 허용 예외 **2가지만**: (1) Codex 실패 복구 (2) 사용자 "직접 해" 명시
- ~~1~3줄 외과적 수정 예외~~ → **폐지**. 아무리 작아도 Codex
- 설계 결정 / 분석 / 리뷰 / 사용자 질문 답변 → Claude
- "Codex할까요?" 묻지 말고 선언하고 바로 위임

**GAN 루프 Tiered 전략:**
- 기본: Codex가 전부 담당 (생성·수정·평가)
- Claude 호출은 **에스컬레이션 조건에서만**: 실패 재시도 / UX 감도 마무리 / 제품 결정 / 고위험 리팩토링
- 무분별한 GAN 반복 금지. 고위험·사용자 접점 작업에만 선별 사용
- Task-split 원칙: Claude=UI/craft/감도, Codex=기계적/백엔드/반복

**감시 프로토콜 (농땡이 방지):**
- **작업 선언**: 모든 구현 작업 시작 전 Claude는 `[담당자] 이유` 1줄 선언. 예: `[Codex] 5파일 rename이라 위임` / `[Claude] 설계 판단 필요`
- **세션 종료 리포트**: 사용자가 "분담 정리해" 요청 시 이번 세션 delegation 로그 요약 (Claude 몇 회, Codex 몇 회, 각각 뭐 했는지)
- **Codex 품질 체크**: Codex 결과는 Claude가 `git diff`로 리뷰. 합격 기준 미달 시 재위임 또는 Claude 직접 보완
- **거짓 위임 금지**: Claude가 직접 해놓고 "Codex에 맡겼다"고 보고 금지. 실제 `mcp__codex-cli__codex` 호출 시에만 Codex 담당으로 표기
