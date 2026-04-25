---
name: Supabase 2026-Q1 새 API 키 포맷 + Edge Function 게이트웨이
description: sb_publishable_* / sb_secret_* 키를 Edge Function 호출에 쓰려면 verify_jwt=false 필수. 공식 제약사항
type: reference
originSessionId: 8be25919-2c97-455e-ae07-93f530ac16a4
---
Supabase가 2026-Q1부터 API 키 포맷 변경:
- **`sb_publishable_*`** — 프론트 공개 키 (legacy `anon` JWT 대체)
- **`sb_secret_*`** — 서버 비공개 키 (legacy `service_role` JWT 대체)

## 🔴 Edge Function 제약

신형 키는 **JWT 포맷이 아니다**. Edge Function 게이트웨이는 기본으로 Authorization 헤더를 JWT로 파싱 → 신형 키를 받으면 **HTTP 401 `UNAUTHORIZED_INVALID_JWT_FORMAT`** 반환.

**공식 문서 원문** ([API Keys docs](https://supabase.com/docs/guides/api/api-keys)):
> "Edge Functions only support JWT verification via the anon and service_role JWT-based API keys. You will need to use the `--no-verify-jwt` option when using publishable and secret keys."

## Fix (canonical)

**Option A (권장)**: `supabase/config.toml`에 함수별 블록 추가
```toml
[functions.<function-name>]
verify_jwt = false
```
후 `supabase functions deploy --project-ref <ref>`

**Option B (안전망 병행)**: CLI flag
```bash
supabase functions deploy --no-verify-jwt --project-ref <ref>
```

**🟡 권장: A + B 병행**. [CLI Issue #4059](https://github.com/supabase/cli/issues/4059) — 업데이트 시 config.toml 무시되는 버그 있음.

## Gotchas

1. **자체 인증 필수**: `verify_jwt = false` 시 함수 내부에서 따로 인증 로직 필요. 그렇지 않으면 누구나 호출 가능
2. **AIT/Vercel 번들 재빌드 불필요**: 서버측 게이트웨이 설정이므로 클라이언트 키·URL 그대로 즉시 복구
3. **CORS와 무관**: verify_jwt 설정은 CORS/OPTIONS 처리에 영향 없음
4. **PostgREST 직접 호출**: `supabase-js` client로 테이블 직접 조회하는 경로는 verify_jwt 무관, RLS만 적용

## 언제 적용

- Edge Function이 자체 인증 (커스텀 헤더, OAuth token 파싱 등)하는 경우 → `verify_jwt = false` 맞음
- Edge Function이 Supabase Auth 유저만 허용해야 하는 경우 → legacy JWT 키 유지 또는 함수 내부에서 custom JWT 검증
