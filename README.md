# JARVIS-OS v1.1

> 제작: Ben(이치훈) · GitHub @jaechi-factory
> **Claude Code를 자비스처럼 똑똑하게 굴리는 운영체계**
> v1.1 (2026-04-30): 자가 회복 메커니즘 + 디렉터·L3 휘하 스킬 자동 발화 매핑 + Codex hook 통합

영화 아이언맨의 자비스가 토니 스타크의 모든 걸 알아서 처리하듯, JARVIS-OS는 Claude Code 안에서 **5단 조직(Founder → CEO 자비스 → C-Level → Leader → Worker)** + **자동 검증** + **자가 치유**가 굴러가는 시스템이에요.

## 🎯 누구한테 좋은가

- Claude Code를 **매번 비슷한 룰을 외우면서 쓰기 귀찮은 사람**
- 디자이너·기획자·풀스택 제작자가 **AI 비서로 자비스급 자율 운영** 원할 때
- 룰 정합성·도구 충돌·메모리 관리를 **자동으로 처리**하고 싶을 때

## ✨ 무엇이 들어 있나

| 영역 | 내용 |
|---|---|
| **5단 조직** | Founder(나) → CEO 자비스 → C-Level 6명 → Leader 32명 → Worker 218명 |
| **5블록 리포트** | 위임할 때마다 누가 누구한테 뭘 시켰는지 한 화면에 |
| **자동 푸터** | 매 응답 끝에 도구 호출 트레이스 (외울 필요 없음) |
| **자동 정합성 검사** | `/check-rules` 16개 항목, 룰 변경 시 자동 발동 |
| **Audit Log** | 모든 도구 호출 자동 기록 (거짓 보고 잡힘) |
| **ABSOLUTE 소통** | 정보 양질 + 누구나 이해 + 존중 구어체 |
| **Codex 위임 강제** | 코드 수정은 Codex가 / 판단·리뷰는 Claude가 |
| **🆕 자가 회복 메커니즘** | 디렉터 누락 위반 감지 → 다음 턴 자비스에게 자동 회복 알림 inject (`hooks/violation-check.sh` + `violation-inject.sh`) |
| **🆕 휘하 스킬 자동 발화 매핑** | 디렉터 6명 + L3 32명 정의에 키워드→스킬 매핑 분산 (총 약 340개 매핑). 디렉터 호출 시 자기 휘하 스킬 자동 후보로 |
| **🆕 Codex 위임 정책 3단계** | `strict` (기본·차단) / `advisory` (권장만) / `off` (Claude 직접 가능). `~/.claude/state/codex-policy` 마커로 즉시 전환 |
| **🆕 플러그인 자동 갱신** | SessionStart hook이 7일 초과 감지 → 백그라운드 `claude plugin update` 일괄 → 다음 세션에 자비스 응답 첫 줄에 변경 알림 강제 노출 (`hooks/session-start-plugin-check.sh` + `weekly-plugin-update.sh`) |
| **플러그인 26개** | superpowers / pm-skills / designer-skills 등 자동 설치 |

## 🚀 온보딩 (30초 시작)

### 시나리오 A — Claude Code에 URL 한 줄 입력 (권장)

Claude Code 첫 메시지에 아래 한 줄만 입력:

```text
https://github.com/jaechi-factory/jarvis-os 설치해줘
```

Claude 온보딩 표준 흐름:

1. README를 읽고 JARVIS-OS를 3~5줄로 설명
2. 아래 질문으로 이름 확인
   - `어떻게 불러드릴까요? (한글 이름이나 닉네임)`
3. 입력한 이름으로 `{{USER_NAME}}` placeholder 전체 치환
4. 자동 설치 실행 (`setup.sh`) 후 설치/검증 결과 요약

온보딩 중 Claude가 먼저 보여줄 설명(권장 문구):

- JARVIS-OS는 Claude Code를 팀처럼 운영하는 설정 묶음이에요.
- 룰, 훅, 에이전트, 프롬프트, 메모리 템플릿을 한 번에 세팅해줘요.
- 설치 후에는 "자비스" 호명과 사용자 이름을 같이 인식해요.
- `/check-rules` 검증과 도구 호출 추적까지 자동으로 켜져요.

### 시나리오 B — 터미널에서 `setup.sh` 실행

```bash
bash <(curl -sL https://raw.githubusercontent.com/jaechi-factory/jarvis-os/main/setup.sh)
```

실행하면 stdin interactive prompt가 뜹니다:

```text
Enter your name:
```

입력한 이름으로 동일한 설치 흐름이 적용됩니다.

### 자동 설치 범위

- CLI: `~/.claude` 디렉토리/프로젝트 메모리 구조 생성
- Hooks: `core/hooks/*` → `~/.claude/hooks/*` 복사 + 실행 권한
- Rules/Commands/Agents/Prompts/Modes: `core/*` → `~/.claude/*` 복사
- MD 파일: `{{USER_NAME}}` 치환 후 배치 (`CLAUDE.md`, `AGENTS_SYSTEM.md` 등)
- Memory templates: `memory-templates/*` → `~/.claude/projects/<slug>/memory/*`
- Plugins 26개: `settings.json` 자동 생성 + enable
- Skills 번들: superpowers / pm-skills / designer-skills / ui-ux-pro-max 자동 활성
- 설치 검증: `/check-rules` + CLI/plugin/skill/hook/agent/MCP 상태 PASS/WARN/FAIL 자동 점검

### 자동 설치 후 사용자 직접 설정 필요

- GitHub MCP 토큰 발급/연동: https://github.com/settings/personal-access-tokens/new
- Figma 토큰 발급/연동: https://www.figma.com/developers/api
- Codex CLI 설치(필요 시): `npm install -g @openai/codex`
- MCP 서버 연결 확인: `claude mcp list` (codex-cli / github / figma 수동 추가 가능)

### 설치 후 (3분)

1. **Claude Code 재시작** (`claude` 다시 실행)
2. **본인 프로필** 작성: `~/.claude/projects/<slug>/memory/global/user_profile.md`
3. **자비스에게 인사**: `"자비스, 안녕"` 또는 `"<내 이름> 누구야?"`

## 📚 더 보기

- [INSTALL.md](./INSTALL.md) — 단계별 상세 설치 가이드
- [docs/how-it-works.md](./docs/how-it-works.md) — 시스템 동작 원리
- [docs/customization.md](./docs/customization.md) — 본인 프로젝트·메모리 추가법
- [docs/troubleshooting.md](./docs/troubleshooting.md) — 문제 해결

## 🛡️ 안전

- **자동 백업**: 설치 시 기존 `~/.claude` 통째 백업 → `~/.claude.backup-YYYYMMDD-HHMMSS`
- **사고 시 복구**: 백업 폴더로 되돌리기만 하면 끝
- **defaultMode: acceptEdits**: Edit/Write는 자동 승인, Bash 첫 호출은 확인 (디자이너 친화)

## 🙋 사전 조건

- macOS (Linux도 가능, 일부 검증 필요)
- [Claude Code CLI](https://claude.ai/code) 설치
- Python 3 (`python3 --version`)
- Git

## 📜 라이선스

**[MIT License](./LICENSE)** — 자유롭게 사용·수정·재배포 가능. 저작권 표시(`Copyright (c) 2026 Ben (이치훈) · jaechi-factory`)만 유지하면 OK.

- ✅ 상업적 사용·재배포 가능
- ✅ 수정·fork·사적 사용 자유
- ✅ Pull Request 환영
- ⚠️ 보증 없음 (`AS IS`)

## 🔄 v1.1 변경 사항 (2026-04-30)

### 🆕 추가
- **자가 회복 메커니즘** (`hooks/violation-check.sh` + `hooks/violation-inject.sh`)
  - Stop hook이 직전 턴 디렉터 키워드 매칭 + Agent 호출 0건 감지 → `.last-violation` 기록
  - 다음 턴 시작 시 UserPromptSubmit hook이 자비스에게 회복 알림 inject
  - 자비스가 알림 보고 자동으로 디렉터 호출하거나 `🧭 L1 (direct · 사유)` 명시
  - 직전 턴 응답에 `🧭 L1 (direct` 라벨 있으면 면제 (false positive 방지)
- **디렉터 6명 휘하 스킬 매핑** (`agents/<director>.md`의 "🎯 휘하 스킬 자동 발화 후보" 섹션)
- **L3 32명 자기 핵심 스킬 매핑** (`agents/<L3>.md`의 "🎯 핵심 사용 스킬" 섹션)
- **AGENTS_SYSTEM 트리거 표 STRICT 강화** + direct 면제 명시 + 자비스 OS 자체 작업 면제

### 🔧 정비
- **Codex hook 7개 → 3개 통합** (`codex-gate-pre/post/summary.sh`)
  - 옛 5개(`codex-declaration-check`, `codex-log`, `codex-size-check`, `codex-statusline`, `codex-turn-reset`)는 `hooks/_archive_codex/`로 이동
  - 통합 hook은 비가역 차단 + 고위험 경로 감지 + Codex 적대적 리뷰 강제
- **`check-rules.sh` SLUG 점→대시 치환 패치** (예: `/Users/jane.smith` → `-Users-jane-smith`)

### 📊 정합성
- `/check-rules`: PASS 15 / WARN 1 / FAIL 0 (총 16 검사)
- 자동 로드 사이즈: ~53KB (디렉터·L3 매핑은 호출 시만 로드)

### 🔄 v1.0 → v1.1 업그레이드
이미 v1.0 설치됐다면 `setup.sh` 다시 실행 시 자동 갱신 (기존 `~/.claude`는 `~/.claude.backup-YYYYMMDD-HHMMSS`로 백업).

---

## 🔄 v1.2 변경 사항 (2026-04-30)

### 🆕 Codex 위임 정책 3단계 옵션

설치 후 본인 작업 스타일에 맞게 정책 즉시 전환 가능 (`~/.claude/state/codex-policy` 마커 파일):

| 정책 | 동작 | 추천 |
|---|---|---|
| `strict` (기본) | `.ts/.tsx/.js/.jsx/.css/.scss` 직접 수정 차단 → `mcp__codex-cli__codex` 강제 | Codex 활성 + 토큰 효율 우선 |
| `advisory` | 차단 X, 권장 메시지만 표시 | Codex와 Claude 혼용 |
| `off` | 메시지 없이 Claude 직접 수정 가능 | Codex 비활성·솔로 모드 |

**전환 명령**:
```bash
echo "advisory" > ~/.claude/state/codex-policy   # 또는 strict / off
```

설치 직후 기본값은 `strict`. 설치 시 `setup.sh`가 prompt로 선택 받을 수 있음 (구현 예정).

### 📜 LICENSE 추가
MIT License (Copyright 2026 Ben · jaechi-factory). 상업 사용·재배포 자유.

---

## 🤝 만든이

Ben(이치훈) (jaechi-factory) — 한국인 풀스택 개발자
