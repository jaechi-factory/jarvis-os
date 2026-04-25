# 문제 해결 (Troubleshooting)

## 설치 단계 문제

### `setup.sh: Permission denied`
실행권한 추가:
```bash
chmod +x setup.sh
bash setup.sh
```

### `Claude Code CLI가 없습니다`
먼저 Claude Code 설치: https://claude.ai/code

### `Python 3이 필요합니다`
macOS:
```bash
brew install python3
```
Ubuntu/Debian:
```bash
sudo apt install python3
```

### 깃허브 인증 실패 (private repo)
ben한테 collaborator 초대 받은 후:
```bash
gh auth login
```

## 실행 단계 문제

### `/check-rules` 실행했는데 FAIL 나옴

각 항목 메시지 확인. 자주 나오는 케이스:

#### `Hook 실행권한` FAIL
```bash
chmod +x ~/.claude/hooks/*.sh
```

#### `자비스 호칭` WARN (4 미만)
일부 룰 파일에 자비스 호칭 누락. 정상 설치 시 자동으로 4개 등록되니, 만약 WARN 나면:
```bash
grep -l "자비스" ~/.claude/CLAUDE.md ~/.claude/AGENTS_SYSTEM.md \
    ~/.claude/projects/*/memory/MEMORY.md \
    ~/.claude/projects/*/memory/global/feedback_role_model_absolute.md
```
4개 다 나와야 정상.

#### `MEMORY 1줄 룰` WARN (200자 초과)
인덱스 항목 중 너무 긴 게 있음. MEMORY.md 열어서 200자 넘는 줄을 짧게.

### 자동 푸터가 안 나옴

원인 1: settings.json hook 등록 실패
```bash
python3 -c "
import json
s = json.load(open('$HOME/.claude/settings.json'))
print('Stop hooks:', len(s['hooks'].get('Stop', [])))
"
```

`Stop hooks: 1` 이상 나와야 정상. 0이면 settings.json 다시 복사:
```bash
cp ~/jarvis-os/settings.template.json ~/.claude/settings.json
```

원인 2: audit-summary.sh 실행권한 없음
```bash
chmod +x ~/.claude/hooks/audit-summary.sh
```

### 자비스 호명 응답 안 함

원인 1: Claude Code 재시작 안 함
```bash
# 현재 세션 종료
# 다시 실행
claude
```

원인 2: CLAUDE.md 자동 로드 실패
```bash
ls ~/.claude/CLAUDE.md
head -20 ~/.claude/CLAUDE.md  # ABSOLUTE 역할 모델 보여야 정상
```

### 플러그인 26개 자동 설치 안 됨

`~/.claude/settings.json` 의 `enabledPlugins` 확인:
```bash
python3 -c "
import json
s = json.load(open('$HOME/.claude/settings.json'))
print(len(s.get('enabledPlugins', {})), '개 플러그인 등록됨')
"
```

`26개 플러그인 등록됨` 나와야 정상. 만약 빈값이면 settings.json 다시 복사.

플러그인 자동 설치는 Claude Code 재시작 후 처음 실행할 때 진행됨. 약 1~2분 걸림.

## 사고 시 복구

### 옛 ~/.claude로 되돌리기

설치 시 자동 백업 위치:
```bash
ls ~/.claude.backup-*
```

복구:
```bash
rm -rf ~/.claude
mv ~/.claude.backup-YYYYMMDD-HHMMSS ~/.claude
```

### 본인이 작성한 user_profile / projects 메모리는?

`setup.sh`는 다음 파일들을 **보존**함:
- `~/.claude/projects/<slug>/memory/global/user_profile.md`
- `~/.claude/projects/<slug>/memory/projects/*`
- `~/.claude/projects/<slug>/memory/MEMORY.md` (이미 있으면)

만약 실수로 덮어썼다면 백업 폴더에서 복원:
```bash
cp ~/.claude.backup-*/projects/*/memory/global/user_profile.md \
   ~/.claude/projects/*/memory/global/
```

## 자비스가 평소처럼 답 안 함

증상: 5블록 안 쓰고, 자비스 호칭 응답 안 하고, 일반 Claude처럼 답.

원인:
1. CLAUDE.md 못 읽음 (재시작 안 함)
2. 너무 짧은 단순 질문이라 5블록 면제 (정상)
3. 룰 파일 어딘가 깨짐

진단:
```bash
# 자비스에게 직접 물어보기
"자비스, /check-rules 돌려줘"
```

PASS=16 나오면 시스템 정상. 그래도 자비스 응답 안 하면 Claude Code 재시작.

## 도움 요청

GitHub Issues: https://github.com/jaechi-factory/jarvis-os/issues

또는 ben에게 직접 연락.
