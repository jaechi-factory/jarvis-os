# INSTALL — JARVIS-OS v1.0 설치 가이드

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

→ Claude가 알아서:
1. 깃허브에서 다운로드
2. 기존 `~/.claude` 자동 백업
3. 룰·hook·메모리·플러그인 다 설치
4. `/check-rules` 16/16 PASS 검증
5. "재시작하세요" 안내

### 🟢 방법 B — 터미널에 한 줄

```bash
bash <(curl -sL https://raw.githubusercontent.com/jaechi-factory/jarvis-os/main/setup.sh)
```

### 🟡 방법 C — 수동 (디버깅용)

```bash
git clone https://github.com/jaechi-factory/jarvis-os.git
cd jarvis-os
bash setup.sh
```

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
모든 항목이 ✅ PASS 나오면 정상:
```
PASS=16 · WARN=0 · FAIL=0
```

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
