# Codex Delegation Protocol

Claude↔Codex 협업 규칙. **기본값은 Codex.**

## 작업 선언 (MANDATORY)

모든 구현 작업 시작 전, **1줄 선언** 후 진행:

```
[Codex] results/index.tsx + home/index.tsx 수정 — 다파일 위임
[Claude] AddPage.tsx 수정 — Codex 실패 복구 이어받기
```

- 선언 없이 코드 수정 시작 금지
- 실제 `mcp__codex-cli__codex` 호출 없이 "Codex 위임"으로 표기 금지

---

## 분담 기준

**파일을 건드리는 모든 작업 → Codex 기본값.**

Claude 직접 수정 허용 예외 2가지만:

| 예외 | 조건 |
|---|---|
| Codex 실패 복구 | Codex 토큰 소진·실패 시 Claude 이어받기 |
| 사용자 명시 요청 | "직접 해", "Claude가 해" 명시 시 |

**"1~3줄이라도 Claude가 직접" 예외는 폐지.** 줄 수·파일 수 무관하게 Codex 위임.

---

## Codex 토큰 소진 시 Claude 이어받기

Codex가 토큰 소진 또는 중간 실패하면:

1. `git diff`로 어디까지 완료됐는지 확인
2. 남은 작업 범위 파악
3. Claude가 이어서 처리 (선언: `[Claude] Codex 이어받기 — 토큰 소진`)

Codex 한 번 호출 = 원자 단위 하나. 끊기면 Claude가 릴레이.

---

## 위임 전 체크리스트

1. `git commit` 또는 stash → 롤백 포인트 확보 (호출당 1개)
2. 원자 단위로 정의: 하나의 목표 + 허용 파일 리스트 + 합격 기준
3. `workingDirectory` 파라미터 전달, 경로는 절대경로
4. **스냅샷 한 줄 메모**: Codex 호출 전 응답에 `HEAD=<short-sha> / 파일=<path>:<line range> / 목표=<one-line>` 표기. 중간에 끊기거나 토큰 소진 시 이 한 줄로 "어디부터 이어받을지" 즉시 판단 가능 → git diff·grep·재읽기 과정 최소화

다음 중 하나라도 해당하면 **쪼개서** 여러 Codex 호출로:
- 2개 이상 서브시스템 걸침
- 10분 안에 diff 리뷰 불가능

## 브리핑 방식

- **인라인 복붙**: 파일 100줄 이하 + 1회성
- **"직접 읽어"**: 100줄 초과 / 재사용 / 다파일 — 경로만 전달
- 프롬프트 구조: 목표 + 제약 + 허용 파일 + 합격 기준. 전체 파일 덤프 금지

## 실패 복구

**Truth source**: `git status` + `git diff`

**복구 플로우**:
1. Codex 결과 에러/불완전/토큰 소진 감지
2. `git diff`로 디스크 상태 파악
3. 판단:
   - 거의 완료 → Claude가 직접 마무리
   - 많이 남음 → 새 Codex 호출에 "여기까지 됐고 이 부분부터" briefing
   - 엉망 → `git reset --hard`로 원복 후 재시도

**리뷰 주기**: 매 Codex 호출마다 diff 리뷰. 배치 금지.

## 사용자 UX

비개발자 사용자는 이 규칙을 외울 필요 없음. Claude가 자동 판단·선언·위임. 사용자는 `[Claude]` 또는 `[Codex]` 선언만 보면 됨.
