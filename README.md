# JARVIS-OS v1.3

> 제작: Ben(이치훈) · GitHub @jaechi-factory
> **Claude Code를 자비스처럼 똑똑하게 굴리는 운영체계**
> v1.3 (2026-05-01): settings.json 자동 병합 설치 + dry-run preview
> v1.2 (2026-05-01): Codex 위임 정책 3단계 + 플러그인 자동 갱신 + LICENSE 추가
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
| **🆕 자가 회복 메커니즘** | 디렉터 누락 위반 감지 → 다음 턴 자비스에게 자동 회복 알림 inject (`hooks/violation-check.sh` + `violation-inject.sh`) |
| **🆕 휘하 스킬 자동 발화 매핑** | 디렉터 6명 + L3 32명 정의에 키워드→스킬 매핑 분산 (총 약 340개 매핑). 디렉터 호출 시 자기 휘하 스킬 자동 후보로 |
| **🆕 Codex 위임 정책 3단계** | `strict` / `advisory` / `off` 중 선택. 기본값은 `strict`. `~/.claude/state/codex-policy`로 즉시 전환 |
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

### 🔀 settings.json 처리 방식 (v1.3 — 자동 병합)

`setup.sh`는 기존 `~/.claude/settings.json` 유무에 따라 자동 분기:

| 케이스 | 동작 |
|---|---|
| **기존 settings.json 없음** | `settings.template.json`을 그대로 복사 (신규 설치) |
| **기존 settings.json 있음** | 백업 → 자동 병합 → preview 생성 → 적용 (사용자 설정 보존) |

**자동 병합 4단계** (기존 사용자 케이스):
1. `~/.claude/settings.json` → `settings.json.before-jarvis-os`로 백업
2. `core/scripts/merge-settings.py` 호출 → `settings.json.jarvis-merged-preview` 생성
3. preview를 최종 `~/.claude/settings.json`에 적용 (`mv`)
4. 롤백 명령 자동 안내 (실패 시): `mv settings.json.before-jarvis-os settings.json`

**머지 정책** (필드별):

| 필드 | 전략 | 충돌 시 |
|---|---|---|
| `permissions.allow` / `deny` / `additionalDirectories` | 합집합 + 중복 제거 (경로는 정규화) | N/A |
| `permissions.defaultMode`, `theme`, `alwaysThinkingEnabled` | 단일값 | 사용자 우선 |
| `hooks.<phase>` | matcher별 합집합. **JARVIS 먼저 + 사용자 나중** | command 정확 일치 시 1회만 등록 |
| `enabledPlugins` | 합집합 | 사용자 false → false 유지 + 경고 |
| `extraKnownMarketplaces` | 합집합 | source 다름 → 사용자 우선 + 경고 (fork/mirror/사내 source 보호) |
| 알 수 없는 최상위 키 | passthrough | 사용자 값 그대로 보존 |

### 🪝 hook 병합 순서 (사용자가 알아둘 점)

자동 병합 시 **JARVIS 시스템 hook이 먼저 실행되고 사용자 hook이 나중**에 실행돼요. 이유: JARVIS hook(`audit-log`/`violation-check` 등)이 시스템 검증 역할이라 사용자 hook 결과까지 측정하는 게 자연스러워요.

**보안/권한 관련 사용자 hook을 먼저 실행해야 하는 경우**: 설치 후 `~/.claude/settings.json`을 직접 열어서 `hooks.<phase>` 배열 안의 순서를 수동 조정하면 돼요. JSON 그대로 편집해도 되고, 한 항목을 위로 옮기는 정도라 디자이너도 충분히 가능해요.

### 🔍 dry-run으로 미리 보기 (v1.3 신규)

설치 전 병합 결과를 미리 보고 싶으면:

```bash
bash setup.sh --dry-run-settings
# 또는 alias
bash setup.sh --dry-run
```

**dry-run 동작**:
- 실제 파일 변경 0건 (`settings.json` 안 만지고, 백업도 안 만듦)
- 기존 settings가 있으면 임시 디렉토리(`mktemp -d`)에 preview 생성
- 기존 ↔ preview `diff -u` 출력
- 종료 시 임시 디렉토리 자동 정리 (`trap EXIT`)
- `exit 0`으로 깨끗하게 끝남 (이름 온보딩·핵심 복사·`/check-rules` 단계 진행 안 함)

**dry-run diff 읽을 때 주의사항**:
- **JSON 키 순서 변경**은 의미상 변경 아님 (Python dict 삽입 순서 결과)
- **macOS에서 `/tmp`와 `/private/tmp`는 같은 경로**로 정규화되어 둘 중 한쪽이 사라질 수 있음 (심볼릭 링크). 의도해서 둘 다 등록한 거였어도 결과는 한 쪽만 유지됨

### 백업·롤백

기존 사용자 설정은 항상 `~/.claude/settings.json.before-jarvis-os`에 보존돼요. 자동 병합이 마음에 안 들면 한 줄로 되돌리기 가능:

```bash
mv ~/.claude/settings.json.before-jarvis-os ~/.claude/settings.json
```

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

## 🔄 v1.3 변경 사항 (현재 버전 · 2026-05-01)

### 🆕 settings.json 자동 병합 설치

기존 사용자가 박아둔 `permissions.allow`·`hooks`·`enabledPlugins`·사용자 정의 키를 보존하면서 JARVIS-OS 템플릿을 덧입히는 자동 병합 모드.

- **신규 사용자**: 기존 동작 (템플릿 통째 복사)
- **기존 사용자**: 백업 → 자동 병합 → preview 생성 → 적용. 사용자 설정 유지
- 머지 정책: 위 "🔀 settings.json 처리 방식" 섹션 참조
- 백업: `~/.claude/settings.json.before-jarvis-os`로 무조건 보존
- 머지 스크립트: `core/scripts/merge-settings.py` (Python 3, 단독 실행 가능)
- 회귀 테스트: `tests/run-merge-tests.sh` (4 케이스 / 31 어설션, PASS=31 · FAIL=0)

### 🆕 dry-run settings preview

설치 전 병합 결과를 미리 볼 수 있는 옵션:

```bash
bash setup.sh --dry-run-settings   # 또는 --dry-run
```

- 실제 파일 변경 0건
- 기존 settings가 있으면 임시 preview를 만들어 diff 출력
- 임시 디렉토리는 종료 시 자동 정리 (`trap EXIT`)
- 자세한 사용법은 위 "🔍 dry-run으로 미리 보기" 섹션 참조

### 🆕 사용자 설정 보존 정책

자동 병합 시 사용자 의도를 보호하는 5가지 룰:

1. `permissions.defaultMode`·`theme`·`alwaysThinkingEnabled` → **사용자 우선**
2. `enabledPlugins` 사용자 false 명시 → **false 유지** + 경고 (의도된 비활성)
3. `extraKnownMarketplaces` source 다름 → **사용자 우선** + 경고 (fork/mirror/사내 source 보호)
4. `hooks` 같은 command 중복 → 1회만 등록 (이중 실행 방지)
5. 알 수 없는 최상위 키 → **passthrough** (사용자 값 그대로 보존)

### 🔄 v1.2 → v1.3 업그레이드

`setup.sh` 다시 실행하면 끝. 기존 `~/.claude/settings.json`이 있으니 자동 병합 모드로 동작해서 사용자 설정 잃지 않아요. 미리 결과 보고 싶으면 `--dry-run`부터.

---

## 🔄 v1.2 변경 사항 (2026-05-01)

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

설치 직후 기본값은 `strict`. 필요하면 위 명령으로 즉시 전환 가능.

### 🆕 플러그인 자동 갱신 (SessionStart hook 기반)

**기본 동작**: 설치된 모든 Claude Code 플러그인을 매주 1회 자동 점검·갱신.

- **트리거**: SessionStart hook이 `~/.claude/state/last-plugin-update`의 마지막 점검 시점 확인. **7일 초과 시 자동 발동**
- **실행**: `nohup`으로 백그라운드 실행 (세션 시작 안 막음). 모든 플러그인에 `claude plugin update` 일괄 호출
- **알림**: 변경된 플러그인이 1개 이상이면 `~/.claude/notifications/plugin-update-YYYYMMDD.md` 작성 → 다음 세션 시작 시 자비스 컨텍스트에 자동 inject → 메모리 룰(`feedback_plugin_update_alert.md`)로 응답 첫 줄에 강제 노출
- **수동 실행**: `bash ~/.claude/hooks/weekly-plugin-update.sh`
- **강제 트리거**: `echo 0 > ~/.claude/state/last-plugin-update` (다음 세션 시작 시 즉시 실행)
- **파일**: `core/hooks/session-start-plugin-check.sh`, `core/hooks/weekly-plugin-update.sh`

**한계**:
- Mac sleep 중에는 발동 X (Claude Code 켜야 SessionStart hook 발동). 며칠 안 켜도 첫 세션에서 자동 캐치업
- "Restart to apply" — 업데이트된 그 세션은 구버전, 다음 세션부터 적용

### 📜 LICENSE 추가
MIT License (Copyright 2026 Ben · jaechi-factory). 상업 사용·재배포 자유.

### 📊 정합성
- `/check-rules`: **FAIL=0** (정상 케이스: PASS=15 · WARN=1 · FAIL=0, 총 16 검사)
- 자동 로드 사이즈: 환경에 따라 ~53~55KB (목표 < 50KB, 약간 초과는 룰 누적으로 인한 자연 증가)

### 🔄 업그레이드
v1.2 시점에는 사용자가 백업 파일을 직접 비교·옮겨야 했지만, v1.3부터 자동 병합으로 변경됐어요 → 위 "🔄 v1.3 변경 사항 → 🔄 v1.2 → v1.3 업그레이드" 섹션 참조.

---

## 🔄 v1.1 변경 이력 (2026-04-30)

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

### 🔄 v1.0 → v1.1 업그레이드
`setup.sh` 다시 실행 시 자동 갱신 (기존 `~/.claude`는 자동 백업).

---

## 🗺️ 다음 TODO (v1.4 후보)

- ✅ ~~**settings.json 자동 병합 설치**~~ → v1.3에서 완료
- **plugin 자동 업데이트 안정화**: 초보 사용자가 항상 최신 환경을 쓰도록 기본 ON 유지. 단, 실패 알림·수동 OFF 스위치·복구 안내를 강화

---

## 🤝 만든이

Ben(이치훈) (jaechi-factory) — 한국인 풀스택 개발자
