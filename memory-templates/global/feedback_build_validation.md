---
name: 배포 전 빌드 검증 방법
description: npx tsc --noEmit 통과해도 npm run build가 실패할 수 있음. 배포 전 반드시 npm run build 실행.
type: feedback
---

배포 전 `npm run build`로 검증하고 push한다. `npx tsc --noEmit`만으로는 부족하다.

**Why:** 이 프로젝트의 build 스크립트는 `tsc -b && vite build`. `-b`(빌드 모드)는 `--noEmit`보다 엄격하게 타입을 검사하는 케이스가 있음. 실제로 `--noEmit` 통과 → `tsc -b` 실패로 Vercel 배포 에러가 발생한 적 있음 (Recharts TooltipPayload readonly 타입 캐스팅 문제).

**How to apply:** 구현 완료 후 배포 직전 순서:
1. `npm run build` 실행 (Vercel과 동일한 환경)
2. 빌드 통과 확인
3. `git push`

`npx tsc --noEmit`은 빠른 중간 체크용으로만 사용. 최종 검증은 항상 `npm run build`.
