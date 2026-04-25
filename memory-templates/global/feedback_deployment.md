---
name: deployment_workflow
description: 배포 시 Vercel과 GitHub 커밋/푸시를 항상 동시에 진행
type: feedback
---

코드 변경 후 배포 시 `npx vercel --prod` 와 `git commit + git push` 를 항상 한 번에 같이 실행할 것.

**Why:** 사용자가 둘 다 동시에 하길 원함. 따로따로 하면 불필요한 확인 요청이 생김.

**How to apply:** 빌드 성공 후 Vercel 배포와 git commit/push를 순서대로 한 세션에서 처리.
