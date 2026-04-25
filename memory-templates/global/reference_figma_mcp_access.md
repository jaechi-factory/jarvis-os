---
name: Figma MCP 접근 방법
description: Figma MCP 서버(공식 클라우드) 사용법 + get_design_context 실패 시 우회 노하우. 2026-04-25 갱신.
type: reference
originSessionId: 1d3b305e-6d95-4883-bd93-3c8b8a198dbc
---

## 현재 등록된 Figma MCP (2026-04-25 기준)

- **서버**: `figma` → `https://mcp.figma.com/mcp` (공식 클라우드, HTTP)
- **설치 경로**: `claude plugin install figma@claude-plugins-official`로 깔린 plugin이 자동 등록
- **인증**: OAuth (mcp__figma__authenticate / mcp__figma__complete_authentication)

## 폐기된 옛 MCP (참고용 — 절대 다시 쓰지 말 것)

- ~~`figma-developer-mcp` → `http://127.0.0.1:3333/mcp` (로컬)~~ → 2026-04-25 등록 해제 완료
- 죽어있어서 `claude mcp list` 호출 시 매번 `✗ Failed to connect` 잡음 떴음
- 만약 다시 비슷한 로컬 MCP를 보면 즉시 `claude mcp remove <name>`으로 정리

## 도구 사용 노하우 (옛 MCP에서 검증된 패턴 — 새 공식 MCP에서도 호환 추정)

- `get_design_context`는 "You currently have nothing selected" 에러를 자주 반환함
- **해결법**: `get_screenshot` + `get_metadata` 조합으로 우회
  - `get_screenshot(fileKey, nodeId)` → 시각적 디자인 확인
  - `get_metadata(fileKey, nodeId)` → 하위 노드 구조/ID 파악
  - 큰 노드(전체 페이지 등)의 metadata는 결과가 너무 클 수 있음 → 파일로 저장 후 grep/jq로 필요한 노드 검색

- URL 파싱: `figma.com/design/:fileKey/:fileName?node-id=136-1031` → fileKey=`:fileKey`, nodeId=`136:1031` (하이픈을 콜론으로)

## 알려진 fileKey

- **[예시 프로젝트 F] 프로젝트**: `0vljYbjcP1vQ2Y9qb3wWeh`

## Why & How

**Why:**
- 옛 `get_design_context`가 Figma 데스크톱 앱의 선택 상태에 의존하는 것으로 보임. 파일이 열려있어도 특정 노드가 선택되지 않으면 실패
- 공식 클라우드 MCP는 OAuth 기반이라 Figma 계정에 직접 권한 부여 → 옛 로컬 MCP보다 안정적이고 권한 명확

**How to apply:**
- Figma 디자인 참조 시 항상 `get_screenshot`을 먼저 시도하고, 구조 파악이 필요하면 `get_metadata` 사용. `get_design_context`는 백업 옵션으로만
- 새 공식 MCP의 도구 이름이 옛 MCP와 다를 수 있음 → 인증 완료 후 첫 사용 시 노출되는 도구 목록 확인하고 위 우회 패턴이 그대로 유효한지 1회 검증
- 인증 끊기면(토큰 만료 등) `mcp__figma__authenticate` 재호출
