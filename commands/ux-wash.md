---
name: ux-wash
description: 기존 프로젝트의 UI 문구를 일괄 스캔해 번역투·부자연스러운 한국어·매트릭스 위반을 찾아내고 교정안을 제시.
---

# /ux-wash

기존 프로젝트의 UI 문구를 대량 진단·교정. 코드베이스를 스캔해 한국어 UI 문구를 찾고, 각각을 ux-writer 에이전트로 교정.

## 사용법

```
/ux-wash                      # 현재 워킹 디렉토리 전체 스캔
/ux-wash [경로]                # 특정 경로만
/ux-wash --dry-run            # 스캔만, 교정 안 함 (리포트만)
/ux-wash --apply              # 교정안을 실제 파일에 반영
/ux-wash --type=error         # 특정 content_type만
```

## 실행 절차

### 1. 프로젝트 프로파일 감지
- `package.json`, `README.md`에서 서비스명·설명 추출
- Figma/스크린샷/디자인 문서 있으면 참고
- 기존 `UX_WRITING.md` 또는 `tone-guide.md` 있으면 로드
- 없으면 사용자에게 1회 질문: "서비스명/타겟/톤(친근/정중/전문/간결/유쾌)은?"

### 2. UI 문구 추출
아래 패턴을 Grep으로 스캔:
- React/Vue/Svelte: `>한글...<`, `placeholder="한글..."`, `alt="한글..."`, `aria-label="한글..."`, `title="한글..."`
- i18n 파일: `ko.json`, `ko-KR.ts`, `messages/ko/*`, `i18n/ko.*`
- 상수: `const MESSAGES = { ... }`, `const TEXT = { ... }`
- 한글 유니코드 범위 포함: `[\u3131-\u318E\uAC00-\uD7A3]`

각 매치를 `{file, line, content_type 추정, text}` 레코드로 수집.

### 3. content_type 추정 (문맥 기반)

파일명·함수명·변수명에서 힌트:
- `Button`, `Btn`, `CTA`, `action` → button
- `Toast`, `Snackbar`, `Notification` → toast
- `Error`, `error`, `ErrorMessage` → error
- `Empty`, `Placeholder`, `NoData` → empty_state
- `Onboarding`, `Welcome`, `Intro` → onboarding
- 그 외 `<p>`, `<div>` 내부 장문 → body

추정 불가는 body로 폴백하고 리포트에 `[추정 불가]` 표시.

### 4. 배치 교정 (ux-writer 에이전트 호출)

추출된 문구를 **배치 묶음(10~20개씩)**으로 ux-writer에게 전달.
각 묶음마다 JSON 배열 반환 받음.

### 5. 리포트 생성

`ux-wash-report-YYYY-MM-DD.md` 파일 생성:

```markdown
# UX Writing 워싱 리포트

## 요약
- 스캔 파일: N개
- 발견 문구: M개
- 교정 권장(critical+major): K개
- 양호: L개

## 교정 필요 (우선순위 높음)

### [file:line] content_type=error
- 원문: "에러가 발생하였습니다..."
- 개선: "결제가 안 됐어요. 다시 시도해 주세요."
- 진단: [번역투] ...
- confidence: 0.92 (바로 사용)
- 대안 A (shortest): ...
- 대안 B (action_oriented): ...

### [file:line] ...
```

### 6. 적용 모드 (`--apply`)

리포트 확인 후:
1. 사용자에게 "N개 문구 교정 진행? (y/n)" 질문
2. y면 각 파일에서 Edit 도구로 원문→개선안 치환
3. 변경된 파일 목록 출력
4. git diff로 미리보기 제안

## 제약

- 코드 로직은 절대 수정 금지 (UI 문구만)
- 주석 안의 문구는 건너뜀
- 테스트 파일(`*.test.*`, `*.spec.*`)의 문자열은 건너뜀
- `--apply` 전에 반드시 `--dry-run` 또는 리포트 검토 선행
- 사용자가 명시적으로 승인하기 전에는 실제 파일 변경 금지

## 출력 순서

1. 프로파일 감지 결과 요약 (서비스명·톤)
2. 추출 진행 상황 ("파일 N개에서 M개 문구 발견")
3. 배치 교정 진행 (진행도 표시)
4. 리포트 파일 경로 + 상위 이슈 5개 미리보기
5. `--apply` 모드면 적용 확인 프롬프트
