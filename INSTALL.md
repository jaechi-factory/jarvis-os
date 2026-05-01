# INSTALL — JARVIS-OS v1.3 설치 가이드

> 제작: Ben(이치훈) · GitHub @jaechi-factory

## 사전 조건 (5분)

1. **Claude Code CLI 설치** — https://claude.ai/code
   ```bash
   claude --version  # 설치 확인
   ```
2. **Python 3** (hook 동작용)
   ```bash
   python3 --version  # 3.x 나오면 OK
   ```
3. **Git**
   ```bash
   git --version
   ```

설치 안 됐으면 위 링크/명령어로 먼저 깔아주세요.

## 설치 방법 (택 1)

### 🟢 방법 A — Claude Code에 한 줄 (가장 쉬움)

Claude Code 켜고 **첫 메시지**에 그대로 입력:

```
https://github.com/jaechi-factory/jarvis-os 설치해줘
```

→ Claude가 온보딩에서 먼저 이렇게 진행:
1. JARVIS-OS를 3~5줄로 설명
2. `어떻게 불러드릴까요? (한글 이름이나 닉네임)` 질문
3. 입력한 이름으로 `{{USER_NAME}}` placeholder 전체 치환
4. `setup.sh` 실행으로 설치 + 검증
5. 자동 불가 항목(MCP 계정 연동) 직접 설정 안내

권장 온보딩 설명 문구:
- JARVIS-OS는 Claude Code를 팀처럼 운영하는 설정 묶음입니다.
- 룰, 훅, 에이전트, 프롬프트, 메모리 템플릿을 한 번에 설치합니다.
- "자비스" 호명과 사용자 이름 인식을 같이 설정합니다.
- `/check-rules` 검증과 도구 호출 추적도 자동으로 활성화됩니다.

### 🟢 방법 B — 터미널에 한 줄

```bash
bash <(curl -sL https://raw.githubusercontent.com/jaechi-factory/jarvis-os/main/setup.sh)
```

실행 후 interactive prompt:

```text
Enter your name:
```

이름을 입력하면 방법 A와 같은 설치 흐름으로 진행됩니다.

### 🟡 방법 C — 수동 (디버깅용)

```bash
git clone https://github.com/jaechi-factory/jarvis-os.git
cd jarvis-os
bash setup.sh
```

## 자동 설치 범위

- CLI 구조: `~/.claude`, `~/.claude/projects/<slug>/memory`
- Hooks: `core/hooks/*` → `~/.claude/hooks/*` + `chmod +x`
- Rules/Commands/Agents/Prompts/Modes: `core/*` → `~/.claude/*`
- MD 템플릿: `{{USER_NAME}}`를 입력 이름으로 치환
- Memory templates: `memory-templates/*` 복사
- Plugins 26개 + Skills 번들 자동 활성 (`settings.json` 자동 병합/생성, v1.3)

## 🔀 settings.json 처리 방식 (v1.3 — 자동 병합)

`setup.sh`는 기존 `~/.claude/settings.json` 유무에 따라 자동 분기:

| 케이스 | 동작 |
|---|---|
| **기존 settings.json 없음** | `settings.template.json` 그대로 복사 (신규 설치) |
| **기존 settings.json 있음** | 백업 → 자동 병합 → preview 생성 → 적용 (사용자 설정 보존) |

**자동 병합 4단계** (기존 사용자 케이스):
1. `~/.claude/settings.json` → `settings.json.before-jarvis-os`로 백업
2. `core/scripts/merge-settings.py`로 `settings.json.jarvis-merged-preview` 생성
3. preview를 `~/.claude/settings.json`에 적용 (`mv`)
4. 머지 결과·경고 stderr 출력 + 롤백 명령 안내

**필드별 머지 정책**:

| 필드 | 전략 | 충돌 시 |
|---|---|---|
| `permissions.allow` / `deny` / `additionalDirectories` | 합집합 + 중복 제거 (경로는 정규화) | N/A |
| `permissions.defaultMode`, `theme`, `alwaysThinkingEnabled` | 단일값 | 사용자 우선 |
| `hooks.<phase>` | matcher별 합집합. **JARVIS 먼저 + 사용자 나중** | command 정확 일치 시 1회만 등록 |
| `enabledPlugins` | 합집합 | 사용자 false → false 유지 + 경고 |
| `extraKnownMarketplaces` | 합집합 | source 다름 → 사용자 우선 + 경고 (fork/mirror/사내 source 보호) |
| 알 수 없는 최상위 키 | passthrough | 사용자 값 그대로 보존 |

### hook 병합 순서 (사용자가 알아둘 점)

기본은 **JARVIS hook 먼저, 사용자 hook 나중** 실행. JARVIS hook(`audit-log`/`violation-check` 등)이 시스템 검증이라 사용자 hook 결과까지 측정하는 게 자연스러움.

**보안/권한 관련 사용자 hook을 먼저 실행해야 하는 경우**: 설치 후 `~/.claude/settings.json`을 직접 열어서 `hooks.<phase>` 배열 안의 순서를 수동 조정.

### 🔍 dry-run으로 설치 전 미리 보기 (v1.3 신규)

실제 설치 전에 병합 결과만 시뮬:

```bash
bash setup.sh --dry-run-settings
# 또는 alias
bash setup.sh --dry-run
```

**dry-run 동작**:
- 실제 파일 변경 0건 (`settings.json` 안 만지고, 백업도 안 만듦)
- 기존 settings 있으면 임시 디렉토리에 preview 생성 → 기존 ↔ preview `diff -u` 출력
- 종료 시 임시 디렉토리 자동 정리 (`trap EXIT`)
- `exit 0`으로 깨끗 종료 (이름 온보딩·핵심 복사·`/check-rules` 단계 진행 X)

**dry-run diff 읽을 때 주의사항**:
- **JSON 키 순서 변경**은 의미상 변경 아님 (Python dict 삽입 순서 결과)
- **macOS에서 `/tmp`와 `/private/tmp`는 같은 경로**로 정규화되어 둘 중 한쪽이 사라질 수 있음 (심볼릭 링크). 의도해서 둘 다 등록한 거였어도 결과는 한 쪽만 유지됨

### 백업·롤백

기존 사용자 설정은 항상 `~/.claude/settings.json.before-jarvis-os`에 보존. 자동 병합이 마음에 안 들면 한 줄로 되돌리기:

```bash
mv ~/.claude/settings.json.before-jarvis-os ~/.claude/settings.json
```

## 자동 설치 후 사용자 직접 설정 필요

- GitHub MCP 토큰 발급/연동: https://github.com/settings/personal-access-tokens/new
- Figma API 토큰 발급/연동: https://www.figma.com/developers/api
- Codex CLI 설치(필요 시): `npm install -g @openai/codex`
- MCP 서버 연결 확인: `claude mcp list` (codex-cli / github / figma 수동 추가 가능)

## 설치 후 (3단계)

### 1단계 — Claude Code 재시작

현재 Claude Code 세션 종료 후 다시 실행:
```bash
claude
```

자동 로드되는 룰들이 새로 로드되도록 재시작 필요.

### 2단계 — 본인 프로필 작성 (3분)

설치 시 자동으로 빈 템플릿이 생성됐어요:
```
~/.claude/projects/<slug>/memory/global/user_profile.md
```

`<slug>`는 본인 home 경로 기반 (예: `-Users-john`).

자비스에게 "**자비스, 내 프로필 어디 있어?**" 물어보면 정확한 경로 알려줘요.

작성 항목:
- 본업 (예: 프로덕트 디자이너)
- 전문 분야
- AI 도구 활용 목적
- 의사결정 가중치
- 협업 방식

### 3단계 — 자비스에게 인사

```
자비스, 안녕
```

자비스가 5블록 리포트 + 자동 푸터로 응답해요. 이때부터 정상 동작.

## 동작 확인

### `/check-rules` — 룰 정합성 확인
대부분 ✅ PASS, WARN 1건 (rules/common 큰 파일 2개)이면 정상:
```
PASS=15 · WARN=1 · FAIL=0
```
WARN 사유: `rules/common/codex-delegation.md` 6.4KB + `pm-skills-routing.md` 9KB. 콘텐츠 무게 합당해서 의도된 상태.

### 자동 푸터 확인
모든 응답 끝에 다음 같은 블록이 자동 출력되면 정상:
```
━━━ 도구 호출 트레이스 ━━━
이번 턴: Edit×3 Bash×2
세션 누적: ...
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 자비스 호명 응답 확인
"자비스" 호명에 즉시 응답 + 5블록 리포트 사용하면 정상.

### 사용자 이름 호명 테스트

설치 시 입력한 이름으로 아래처럼 질의:

```text
<내 이름> 누구야?
```

이름 기반 컨텍스트로 정상 응답하면 치환/호명 설정이 완료된 상태입니다.

### 핵심 영역 자동 점검 항목

`setup.sh`가 설치 직후 아래 영역을 자동 점검해 PASS/WARN/FAIL로 출력합니다.

- `/check-rules` 정합성 검증 (정상 기준: **FAIL=0**, 일반 케이스 PASS=15 · WARN=1 · FAIL=0)
- CLI 구조 + `claude` 명령 사용 가능 여부
- Hook 파일 수 + 실행 권한
- Rules/Commands/Agents/Modes 파일 수
- Plugin(26) + 핵심 Skill 번들 활성 여부
- 이름 치환 잔존(`{{USER_NAME}}`) 여부
- MCP(codex/github/figma) 연결 감지 또는 수동 확인 필요 경고

### settings.json 자동 병합 검증 (v1.3)

기존 사용자라면 설치 전에 dry-run으로 병합 결과 미리 보기:

```bash
bash setup.sh --dry-run        # 또는 --dry-run-settings
```

**확인 포인트**:
- "기존 settings.json 감지 → 자동 병합 시뮬레이션" 메시지 출력 확인
- diff 섹션에서 추가/삭제될 항목 검토
- ⚠️ 또는 ℹ️ 경고가 있으면 충돌 항목 (사용자 false 유지·source 충돌·passthrough 키 등) 의도한 결과인지 확인

설치 후에는 백업 파일과 직접 비교도 가능:

```bash
diff ~/.claude/settings.json.before-jarvis-os ~/.claude/settings.json
```

## 문제 발생 시

### 백업 위치
설치 시 자동 백업이 만들어졌어요:
```
~/.claude.backup-YYYYMMDD-HHMMSS
```

복구 필요시:
```bash
rm -rf ~/.claude
mv ~/.claude.backup-YYYYMMDD-HHMMSS ~/.claude
```

### 자세한 문제 해결
[docs/troubleshooting.md](./docs/troubleshooting.md) 참조

## 다음 읽을거리

- [README.md](./README.md) — JARVIS-OS 전체 소개
- [docs/how-it-works.md](./docs/how-it-works.md) — 동작 원리
- [docs/customization.md](./docs/customization.md) — 본인 프로젝트 메모리 추가법
