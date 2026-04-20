# Modes Index

온디맨드 로드되는 행동 모드 파일들의 인덱스. **이 파일은 항상 로드됨.**

## Activation Protocol (MANDATORY)

사용자 요청을 받으면 답변 **전에** 아래를 수행:

1. **분류**: 요청이 아래 trigger 중 하나에 해당하는지 판단
2. **로드**: 해당하면 `Read(modes/<file>.md)` 1회 실행
3. **Echo**: 응답 시작부에 활성 모드명 표기 (예: `[modes: research, task-management]`). 활성 모드 없으면 생략
4. **리셋**: 다음 턴에서 요청 성격이 바뀌면 이전 모드 규칙을 끌고 가지 말 것

**한국어 키워드 포함**. 명시 커맨드(`/sc:*`, `--flag`)가 있으면 그게 우선, 없으면 의도 기반 매칭.

## Trigger → File Mapping

| Trigger (영/한/플래그) | 파일 | 용도 |
|---|---|---|
| business-panel, 경영분석, 비즈니스 전략 진단, `/sc:business-panel` | `modes/business-panel.md` | 9인 전문가 패널 (Porter/Christensen/...) 다관점 분석 |
| research, investigate, 리서치, 조사, 탐색, `/sc:research`, `--research` | `modes/research.md` | 딥리서치 설정 (Tavily/Playwright/멀티홉) |
| brainstorm, 아이디어, 막연함, 탐색적 요구사항, `--brainstorm`, `--bs` | `modes/brainstorming.md` | 소크라테스식 요구사항 발굴 |
| introspect, 자기분석, 메타인지, 왜 이렇게 했지, `--introspect` | `modes/introspection.md` | 추론 과정 노출, 패턴 인식 |
| orchestrate, 멀티툴, 병렬, 도구 최적화, `--orchestrate` | `modes/orchestration.md` | 도구 선택 매트릭스, 리소스 관리 |
| task-manage, 복잡한 작업, 3+ 단계, `--task-manage`, `--delegate` | `modes/task-management.md` | 계층적 작업 관리 + 메모리 |
| uc, ultracompressed, 토큰 절감, 심볼, `--uc` | `modes/token-efficiency.md` | 심볼 기반 압축 커뮤니케이션 |
| ux-write, 문구, 라이팅, 카피, copy, 어색, 텍스트 교정, 말이 이상, UX writing, `/ux-write`, `/ux-wash` | `modes/ux-writing.md` | **진입 즉시 `~/.claude/prompts/ux-writer-v6.1.md` Read 필수** — content_type 매트릭스·번역투 사전·규칙 우선순위 적용 |

## Notes

- 모드 파일은 필요시마다 Read — 컨텍스트 캐시에 남아있으면 재Read 생략
- 여러 모드 동시 활성 가능 (예: `task-management` + `orchestration`)
- Mode은 "mindset/behavior" 규칙이며, **PRINCIPLES/RULES/AGENTS_SYSTEM 상위 규칙과 충돌 시 상위 규칙 우선**
