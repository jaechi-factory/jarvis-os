# Flags

상시 로드. 사용자가 명시적으로 타이핑하는 flag만 정의. MCP 상세는 온디맨드.

## Mode Activation Flags

- `--brainstorm` / `--bs` — 모호한 요구사항 발굴 (modes/brainstorming.md)
- `--introspect` — 추론 과정 노출, 메타인지 (modes/introspection.md)
- `--task-manage` / `--delegate` — 복잡한 작업 계층 관리 (modes/task-management.md)
- `--orchestrate` — 도구 선택 최적화, 병렬 (modes/orchestration.md)
- `--research` — 딥리서치 (modes/research.md)
- `/sc:business-panel` — 9인 비즈니스 석학 패널 (modes/business-panel.md)

## Analysis Depth

- `--think` — 표준 분석 (~4K tokens)
- `--think-hard` — 시스템 전반 분석 (~10K tokens)
- `--ultrathink` — 최대 깊이 (~32K tokens)

## Output

- `--uc` / `--ultracompressed` — 심볼 기반 30~50% 토큰 절감 (modes/token-efficiency.md)
- `--scope [file|module|project|system]` — 분석 범위 지정
- `--focus [performance|security|quality|architecture|accessibility|testing]` — 도메인 집중

## Execution Control

- `--loop` — 개선 반복 사이클 활성화
- `--iterations [n]` — 반복 횟수 지정 (1~10)
- `--validate` — 실행 전 리스크 평가
- `--safe-mode` — 최대 검증, 보수적 실행, `--uc` 자동

## Priority Rules

1. **Safety First**: `--safe-mode` > `--validate` > optimization flags
2. **Explicit Override**: 사용자 flag > 자동 감지
3. **Depth Hierarchy**: `--ultrathink` > `--think-hard` > `--think`
4. **Scope Precedence**: system > project > module > file

## MCP Server Flags

`--c7` (Context7), `--seq` (Sequential), `--magic` (21st.dev UI), `--morph` (Morphllm 벌크 편집),
`--serena` (심볼/메모리), `--play` (Playwright), `--chrome` (DevTools), `--tavily` (웹 검색),
`--frontend-verify` (Playwright+Chrome+Serena 결합), `--all-mcp`, `--no-mcp`.

상세 behavior은 필요 시 개별 문서 참조. `--no-mcp`는 모든 MCP 비활성.
