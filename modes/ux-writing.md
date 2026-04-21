# UX Writing Mode

UX 라이팅·문구·카피 작업 시 자동 활성.

## 🔴 트리거 (한 글자라도 매칭 시 자동 진입)

`라이팅` · `문구` · `카피` · `copy` · `ux-write` · `UX writing` · `어색` · `말이 이상` · `텍스트 교정` · `/ux-write` · `/ux-wash`

위 키워드 중 **1개라도** 사용자 입력에 등장하면 본 모드 자동 진입. 다른 모드와 동시 활성 가능.

## 🔴 진입 즉시 실행 (MANDATORY · 예외 없음)

```
Read(~/.claude/prompts/ux-writer.md)
```

- 이 Read **없이** 어떤 문구도 진단·제안·수정·코드 반영 금지
- 컨텍스트에 이미 로드된 상태(같은 세션에서 이전 턴에 읽음)면 재Read 생략 — 단, `/clear` 후 첫 라이팅 작업이면 무조건 다시 Read
- ver 1.0 (2026-04-20 정의) 기준. 파일명은 항상 `ux-writer.md` 고정

## 이 모드가 커버하는 것

- 버튼 / 토스트 / 에러 메시지 / 빈 상태 / 온보딩 / 본문 카피 / tooltip / dialog / banner / cta_link
- 번역투 교정, 기업어투 제거, 톤 일관성 확보, brand_voice 매칭
- 전환 레버 4종(urgency / scarcity / social_proof / loss_aversion) 적용
- `/ux-write` 즉석 교정, `/ux-wash` 일괄 워싱

## spec 로드 후 적용 순서

1. `ux-writer.md`의 content_type 매트릭스 확인 (글자 수 제한)
2. 번역투 사전 14쌍 대조 (수동→능동, 명사형 묶음, 자동화 능동 전환 등)
3. brand_voice 프로파일 매칭 (서비스 톤 일관성)
4. 전환 레버 4종 적용 (urgency / scarcity / social_proof / loss_aversion)
5. Self-Critique 6단계 내부 추론 (진단→후보 3개→1위→자체 검증→self-fix→JSON)
6. 규칙 충돌 시 우선순위: `max_length > 매트릭스 > guidelines > tone`
7. 출력 스키마 준수: suggestion / violations_fixed / applied_rules / reason / alternatives[2] / confidence
