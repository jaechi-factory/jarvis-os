---
name: 직접 배포 실행 원칙
description: Vercel 자동배포에 의존하지 말고 항상 배포 명령어를 직접 실행할 것
type: feedback
originSessionId: c0b28bf9-9cc7-466b-a179-9a05eac26629
---
Vercel 자동배포(main 브랜치 푸시 → 자동 트리거)는 사용하지 않는다. 배포는 무조건 직접 실행.

**Why:** 사용자가 명시적으로 "앞으로 자동 배포는 없어. 무조건 직접배포야"라고 확정함.

**How to apply:**
- `git push` 후 "Vercel이 자동으로 배포됩니다"라고 끝내는 것 절대 금지
- 배포가 필요한 모든 작업에서 `vercel --prod`를 직접 실행하고 결과 URL 확인
- 커밋/푸시와 배포는 항상 별개 단계로 명시적으로 실행
- **⚠️ 알리어스 확인 필수**: `vercel --prod`는 새 deployment URL을 만들지만 `[예시 프로젝트 A]-xi.vercel.app` 같은 커스텀 알리어스가 자동으로 갱신되지 않는 경우가 있음. `vercel alias ls | grep [예시 프로젝트 A]-xi`로 확인해서 최신 deployment를 가리키지 않으면 `vercel alias set <새deployURL> [예시 프로젝트 A]-xi.vercel.app` 실행. 2026-04-17 실제 발생.
