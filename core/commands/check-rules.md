---
description: 룰 시스템 정합성 자동 검사. 호칭·도구 카운트·카탈로그 버전·5블록 SSOT·hook 등록·MEMORY 1줄 룰 등 10개 핵심 개념 일괄 grep + 모순 자동 탐지. 큰 룰 변경 후 1번 돌리면 잠복 모순 즉시 발견.
---

# /check-rules — 룰 정합성 자동 검사

## 동작

`bash ~/.claude/hooks/check-rules.sh` 실행 → 결과 출력.

## 검사 항목 (10개 핵심 개념)

| # | 항목 | 무엇을 검사 |
|---|---|---|
| 1 | 역할 모델 호칭 | "COO" 잔존 여부 (CEO=자비스로 통일됐는지) |
| 2 | L3 카운트 | 23개 vs 32개 — 32개로 통일됐는지 |
| 3 | L4 카운트 | 220개 vs 218개 — 218개로 통일됐는지 |
| 4 | 카탈로그 버전 | frontmatter / 본문 헤더 / MEMORY.md 인용 일치 여부 |
| 5 | 5블록 SSOT | AGENTS_SYSTEM.md 외에 5블록 포맷 정의가 있는지 |
| 6 | ABSOLUTE 위치 | CLAUDE.md 단독으로 ABSOLUTE 헤더 보유하는지 |
| 7 | Audit hook 등록 | settings.json에 audit-log.sh + audit-summary.sh 등록 여부 |
| 8 | Hook 실행권한 | hooks/*.sh 모두 +x인지 |
| 9 | MEMORY 1줄 룰 | 인덱스 항목 200자 초과 여부 |
| 10 | 자비스 호칭 | 4개 핵심 파일에 등록됐는지 |

## 사용 시점

- **큰 룰 변경 후 1번 돌리기** (예: 새 ABSOLUTE 추가, 카탈로그 버전 업, 호칭 변경)
- **새 메모리 파일 추가 후 정합성 확인**
- **세션 시작 직후 sanity check** (선택, {{USER_NAME}}이 의심날 때만)
- 자동 실행 X — {{USER_NAME}}이 명시적으로 호출

## 결과 해석

```
✅ PASS — 정상
⚠️  WARN — 경고 (잠재 위험, 즉시 정정 안 해도 됨)
❌ FAIL — 즉시 정정 필요 (모순 확정)
```

## 출력 예시

```
═══════════════════════════════════════════════════════
 룰 정합성 검사 — 2026-04-25 19:30:00
 검사 대상: 61 파일
═══════════════════════════════════════════════════════

  ✅ [역할 모델 호칭] COO 잔존 0건 (CEO=자비스로 통일)
  ✅ [L3 카운트] 32개 통일 (핵심 23 + 번들 9)
  ✅ [L4 카운트] 218개 통일
  ✅ [카탈로그 버전] v1.4 통일 (frontmatter=본문=MEMORY 인덱스)
  ✅ [5블록 SSOT] AGENTS_SYSTEM.md/REFERENCE.md에서만 정의
  ✅ [ABSOLUTE 위치] CLAUDE.md 단독
  ✅ [Audit hook 등록] PostToolUse audit-log.sh + Stop audit-summary.sh
  ✅ [Hook 실행권한] 모두 +x
  ✅ [MEMORY 1줄 룰] 위반 0건 (200자 컷)
  ✅ [자비스 호칭] 4 파일에 등록

═══════════════════════════════════════════════════════
 결과: PASS=10 · WARN=0 · FAIL=0
 자동 로드 사이즈: 47652 B (목표 < 50000)
═══════════════════════════════════════════════════════
```

## 한계

- **알려진 모순만 잡음** — 이 스크립트가 정의한 10개 패턴 외에 새로운 모순 유형은 못 잡음
- **새 모순 패턴 발견 시** 이 스크립트에 검사 로직 추가하면 됨 (`hooks/check-rules.sh` Edit)
- **의미적 충돌은 못 잡음** — 같은 단어를 다른 의미로 쓰는 경우 (예: 두 메모리 파일이 "리뷰"를 다른 정의로 사용)는 사람이 봐야 함

## 확장

새 모순 유형 발견 시 `hooks/check-rules.sh`에 새 `print_check` 블록 추가:

```bash
# ── 11. 새 검사 항목 ──
HITS=$(xargs grep -Hn "패턴" < /tmp/rule-check-files.txt 2>/dev/null | wc -l)
if [ "$HITS" -eq 0 ]; then
  print_check PASS "새 항목" "정상"
else
  print_check FAIL "새 항목" "$HITS건 발견"
fi
```
