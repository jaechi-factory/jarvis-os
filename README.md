# JARVIS-OS v1.0

> 제작: Ben(이치훈) · GitHub @jaechi-factory
> **Claude Code를 자비스처럼 똑똑하게 굴리는 운영체계**

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
| **플러그인 26개** | superpowers / pm-skills / designer-skills 등 자동 설치 |

## 🚀 30초 설치

### 방법 1 — Claude Code에 한 줄 (마법, 추천)

Claude Code 켜고 첫 메시지로:

```
https://github.com/jaechi-factory/jarvis-os 설치해줘
```

→ Claude가 알아서 다운로드·설치·검증까지 다 해줌. 끝나면 "Claude Code 재시작하세요" 안내.

### 방법 2 — 터미널에 한 줄

```bash
bash <(curl -sL https://raw.githubusercontent.com/jaechi-factory/jarvis-os/main/setup.sh)
```

### 설치 후 (3분)

1. **Claude Code 재시작** (`claude` 다시 실행)
2. **본인 프로필** 작성: `~/.claude/projects/<slug>/memory/global/user_profile.md`
   - 자비스가 첫 세션에서 안내해줌
3. **자비스에게 인사**: `"자비스, 안녕"` → 5블록 + 자동 푸터로 응답 시작

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

비공개 저장소. {{USER_NAME}}이 초대한 사람만 사용.

## 🤝 만든이

Ben(이치훈) (jaechi-factory) — 한국인 풀스택 개발자
