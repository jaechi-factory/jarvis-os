# 본인 정보·프로젝트·메모리 추가법

## 1. 본인 프로필 (필수)

설치 직후 가장 먼저 작성:

```
~/.claude/projects/<slug>/memory/global/user_profile.md
```

`<slug>`는 본인 home 경로 기반 (예: `-Users-john`).

자비스에게 "**자비스, 내 프로필 어디 있어?**" 물으면 정확한 경로 알려줌.

### 작성 항목 (참고)

```markdown
# User Profile

## 기본 정보
- **본업**: 프로덕트 디자이너 (회사명)
- **전문 분야**: 모바일 앱 디자인 / 디자인 시스템
- **AI 도구 활용 목적**: 효율 위임 (코드 자동화 + 의사결정 보조)
- **사용 도구**: Figma / Slack / Notion / Cursor

## 의사결정 가중치
- 디자인 결정: 본인 우선
- 코드 구현: 자비스 자율
- 비가역 액션(커밋·배포): 본인 승인 필수

## 협업 방식
- 응답 언어: 한국어
- 톤: 친근 구어체
- 문서 형식: 표·리스트 선호
```

## 2. 본인 프로젝트 메모리 추가

자주 작업하는 프로젝트별로 메모리 파일을 만들면 자비스가 자동 참고함.

### 위치
```
~/.claude/projects/<slug>/memory/projects/project_<프로젝트명>.md
```

### 예시
```markdown
---
name: 내 프로젝트 X — 핵심 정보
description: 사이드 프로젝트 X의 기술 스택·배포·API 키 등 자주 쓰는 정보
type: project
---

# 프로젝트 X

## 기술 스택
- Next.js 15 / Tailwind / Supabase

## 주요 명령어
- `npm run dev` — 로컬 개발
- `npm run deploy` — 프로덕션 배포

## API 키 위치
- Supabase: Vercel 환경변수
- ...
```

### 인덱스 등록

`~/.claude/projects/<slug>/memory/MEMORY.md` 의 `## Projects` 섹션에 한 줄 추가:

```markdown
- [내 프로젝트 X](projects/project_x.md) — 한 줄 hook
```

→ **메모리 파일을 새로 만들면 자비스가 자동 안내** ("MEMORY.md에 인덱스 추가하세요" 푸터). 외울 필요 없음.

## 3. 트리거 자동 로드 룰 추가

특정 키워드가 등장하면 메모리 파일을 자동 Read하게 만들 수 있음.

`~/.claude/projects/<slug>/memory/MEMORY.md` 의 `🔴 트리거 자동 로드` 섹션에 추가:

```markdown
- **프로젝트X / API키X / 배포X** → 즉시 [`project_x.md`](projects/project_x.md) Read 후 답변
```

→ "프로젝트X 어떻게 배포해?" 물으면 자비스가 메모리 자동 로드.

## 4. 본인 룰 추가

자주 반복되는 피드백을 룰로 만들기:

```
~/.claude/projects/<slug>/memory/global/feedback_<항목>.md
```

예시:
```markdown
---
name: PR 머지 전 빌드 체크 의무
description: 머지 전 npm run build로 검증, 타입체크만은 부족
type: feedback
---

# PR 머지 전 빌드 체크

머지 전 반드시 `npm run build` 실행. `tsc --noEmit`만으로 부족.

**Why**: 2026-04-XX X 프로젝트에서 타입체크 통과했지만 build 실패한 사례.
```

## 5. 본인 슬래시 명령 추가

자주 쓰는 패턴을 슬래시 명령으로:

```
~/.claude/commands/my-command.md
```

```markdown
---
description: (어떤 일 할지 한 줄 설명)
---

# /my-command

(상세 동작 설명)
```

→ Claude Code 재시작하면 `/my-command`로 호출 가능.

## 6. 외부 시스템 통합 (MCP 서버)

[Context7](https://github.com/upstash/context7) / Tavily / Figma 같은 MCP 서버 추가:

```bash
claude mcp add <server-name>
```

자세히는 Claude Code 공식 문서 참고.

## 7. JARVIS-OS 자체 업데이트

{{USER_NAME}}이 새 룰·hook 추가하면:

```bash
cd ~/jarvis-os  # 또는 git clone 했던 위치
git pull
bash setup.sh   # 다시 실행
```

`setup.sh`는 본인이 추가한 user_profile.md, projects/* 메모리는 **건드리지 않음** (보존).
