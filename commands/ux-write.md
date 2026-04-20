---
name: ux-write
description: 한국어 UI 문구를 즉석에서 개선. 버튼/토스트/에러/빈상태/온보딩/본문 모두 지원.
---

# /ux-write

한국어 UX Writing 전문가 호출. 개별 문구 1개 또는 여러 개를 한 번에 교정.

## 사용법

```
/ux-write [서비스명] / [content_type] / [원문]
/ux-write 토닥 / error / 결제에 실패하였습니다
/ux-write "여러 문구 한꺼번에 (줄바꿈으로 구분)"
```

또는 자유 서술:
```
/ux-write 노트앱 저장 완료 토스트인데 "파일이 정상적으로 저장되었습니다" 이거 줄여줘
```

## 동작

1. 사용자 입력을 파싱해 service_profile / ui_context / text 구성
2. `ux-writer` 에이전트 호출 (Agent 도구)
3. 반환된 JSON을 **사용자 친화적 형식으로 변환해서** 출력:

```
✓ 개선안: <suggestion>   (N자, confidence: 0.XX → 바로 사용 / 비교 후 / 리뷰 필요 / 재작성)

  진단: [태그] 근본원인
  적용: <규칙 1>, <규칙 2>

  대안 1 (<variant>): <text>   (N자)
    → <use_when>
  대안 2 (<variant>): <text>   (N자)
    → <use_when>
```

여러 문구이면 각 문구를 위 형식으로 순서대로 출력.

## 누락 필드 처리

- content_type 없으면 텍스트 패턴으로 추론 (실패/오류→error, 완료/성공→toast, ?끝+짧음→button 등)
- max_length 없으면 content_type 매트릭스 상한 적용
- writing_guidelines 없으면 매트릭스만 사용
- 추론한 값은 출력 맨 위에 `[추론: content_type=xxx]` 형태로 명시

## 제약

- 프롬프트 원본(`~/.claude/prompts/ux-writer-v6.1.md`)은 절대 수정하지 말 것
- JSON 원본도 사용자에게 보이지 말 것 (사용자는 친숙한 형식만 봄)
- 원본 JSON을 보고 싶다고 명시하면 그때만 raw JSON도 같이 출력
