# UX Writing Mode

UX 라이팅·문구·카피 작업 시 자동 활성.

## 진입 즉시 실행 (MANDATORY)

```
Read(~/.claude/prompts/ux-writer-v6.1.md)
```

**이 Read 없이 어떤 문구도 수정하거나 제안하지 말 것.**

## 이 모드가 커버하는 것

- 버튼 / 토스트 / 에러 메시지 / 빈 상태 / 온보딩 / 본문 카피
- 번역투 교정, 기업어투 제거, 톤 일관성 확보
- `/ux-write` 즉석 교정, `/ux-wash` 일괄 워싱

## spec 로드 후 적용 순서

1. `ux-writer-v6.1.md`의 content_type 매트릭스 확인 (글자 수 제한)
2. 번역투 사전 10쌍 대조
3. 규칙 충돌 시 우선순위: `max_length > 매트릭스 > guidelines > tone`
4. 출력 스키마 준수: suggestion / violations_fixed / applied_rules / reason / alternatives[2] / confidence
