---
name: 플러그인 자동 갱신 메커니즘 v1.0
description: SessionStart hook 기반 7일 자동 점검. 갱신된 플러그인은 다음 세션에서 자비스에게 자동 알림 → 매핑 재조정 트리거
type: reference
---

# 플러그인 자동 갱신 메커니즘

설치된 Claude Code 플러그인을 매주 1회 자동 점검·갱신. 변경 발생 시 다음 세션에서 자비스에게 자동 알림.

## 작동 방식

매 세션 시작 시 `hooks/session-start-plugin-check.sh`가 두 가지 작업 수행:

1. **미처리 알림 inject** — `~/.claude/notifications/plugin-update-*.md`가 있으면 자비스 응답 시작 시 자동 출력. 처리 후 `notifications/processed/`로 이동
2. **7일 초과 점검** — `~/.claude/state/last-plugin-update` 타임스탬프 확인. 7일 초과면 `weekly-plugin-update.sh`를 백그라운드 실행 (세션 시작 안 막음)

## 파일 구조

| 경로 | 역할 |
|---|---|
| `hooks/session-start-plugin-check.sh` | SessionStart hook (settings.json 등록) |
| `hooks/weekly-plugin-update.sh` | 설치된 모든 플러그인 일괄 `claude plugin update` 실행 |
| `state/last-plugin-update` | 마지막 점검 시점 (Unix timestamp) |
| `logs/plugin-update-YYYYMMDD-HHMMSS.log` | 매 실행 결과 로그 |
| `notifications/plugin-update-YYYYMMDD.md` | 변경된 플러그인 1+개 시 알림 |

## 갱신 빈도 (참고)

활발한 3rd party 플러그인도 메이저 업데이트는 보통 ~3~4주 단위. 주간 점검으로 충분 (일간 점검은 오버킬). 공식 anthropics 플러그인은 GCS 기반 자동 동기화로 거의 항상 최신.

## 자비스 후속 조치 (알림 받았을 때)

알림이 inject되면 자비스가 다음을 자율 판단·진행:

1. 변경된 플러그인의 새 스킬·트리거 확인
2. 디렉터별 매핑 재조정 필요 여부 검토
3. 필요 시 `/check-rules`로 정합성 검증
4. 매핑 변경 시 해당 디렉터 정의 파일 (`~/.claude/agents/<director>.md`) 수정

## 한계

- macOS Mac이 sleep 상태면 SessionStart 안 일어남 → 사용자가 Claude Code 켜야 작동. 며칠 안 켜면 갱신 지연되지만, 첫 세션에서 자동 캐치업
- "Restart to apply" — 업데이트 후 그 세션은 구버전. 다음 세션부터 적용. 7일 사이클이라 실용상 무관
- 자동 매핑 재조정은 알림만 띄우고 실제 작업은 자비스 자율 판단 (완전 자동 X)

## 수동 호출

즉시 점검하려면:
```bash
bash ~/.claude/hooks/weekly-plugin-update.sh
```

또는 강제 트리거 (다음 세션 시작 시 자동 실행):
```bash
echo 0 > ~/.claude/state/last-plugin-update
```
