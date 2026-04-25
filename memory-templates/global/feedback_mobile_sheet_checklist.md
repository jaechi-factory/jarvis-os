---
name: 바텀시트/모달 구현 기초 체크리스트
description: 바텀시트·모달·플로팅 UI 추가/수정 시 배포 전 반드시 점검할 기본 항목. 하단 여백·safe-area 누락 반복 방지
type: feedback
originSessionId: 09264c5f-70d5-4ff7-80bb-7b8bf4c176b8
---
바텀시트/모달/플로팅 CTA 구현 시 배포 전 이 체크리스트를 반드시 먼저 훑고, 어긴 채 "완료" 보고 금지.

**Why:** 2026-04-17 [예시 프로젝트 A] 폴더 바텀시트 구현 시 `.folder-bottom-sheet`의 padding-bottom을 0으로 두고 safe-area-inset-bottom도 빠뜨린 채 배포 → 버튼이 화면 하단에 딱 붙고 iOS home indicator 영역과 겹쳐 보임 → 사용자가 "엉망"이라 지적. CSS만 만지는 작업이라 가볍게 처리하다가 기본 체크를 건너뜀.

**How to apply:** `position: fixed`의 bottom sheet, sticky CTA, 플로팅 버튼, 모달 등 **화면 하단에 붙는 UI**를 작성/수정할 때는 코드 작성 후 배포 전에 아래 항목을 모두 통과시킨 뒤에만 "완료" 보고.

## 필수 체크

1. **하단 여백 + safe-area**
   - `padding-bottom: calc(16~24px + env(safe-area-inset-bottom))` 또는 동급 구조
   - iOS notch/home indicator 기기(iPhone X+)에서도 버튼이 가려지지 않는지

2. **상단 여백 (바텀시트)**
   - `padding-top: 20~24px` + 가능하면 drag handle(grabber) 12px
   - border-radius는 상단만: `border-radius: 16~20px 16~20px 0 0`

3. **좌우 여백**
   - `padding-left/right: 16~20px` — 내부 컨텐츠가 가장자리에 붙지 않음
   - 내부 아이템이 full-bleed 필요하면 아이템 자체에 동일 padding

4. **콘텐츠 스크롤 vs 고정 CTA**
   - `max-height: 80dvh` 등으로 전체 높이 제한
   - 콘텐츠 영역만 `overflow-y: auto`, CTA는 bottom에 고정
   - CTA 영역 상단에 `border-top` 또는 shadow로 시각적 분리

5. **CTA 버튼**
   - 최소 높이 48~52px (터치 타겟)
   - `display: flex; flex: 1;`로 균등 분배
   - `disabled` 상태 스타일 (opacity 0.5)

6. **오버레이 (dimmer)**
   - `background: rgba(0,0,0,0.4~0.6)`
   - `onClick`으로 닫기 (`e.stopPropagation` 내부에서)
   - `z-index`: 오버레이 < 시트 < toast

7. **접근성**
   - `role="dialog"` + `aria-modal="true"`
   - ESC 키 닫기
   - 포커스 트랩 (가능하면)

## 배포 전 시각 확인 의무

- CSS 변경 후 **반드시 Playwright 또는 실기기로 바텀시트를 직접 열어 스크린샷 확인**
- 열린 상태 + 닫힌 상태 + 콘텐츠 많은 경우(스크롤) + 적은 경우(여백) 각각 확인
- 스크린샷에서 하단이 safe area와 겹치지 않고 충분한 시각 여백이 있는지 육안 검증

## TDS 같은 외부 컴포넌트 라이브러리 사용 전 점검

- Provider/Context 의존성 확인 ([예시 프로젝트 A] TDS는 AIT 전용 — 웹에서 throw)
- 타겟 환경(웹/AIT/네이티브)에서 실제 렌더 가능한지 **먼저 로컬 dev 서버로 확인**
- 빌드 통과 ≠ 런타임 렌더 성공. 브라우저 콘솔 에러 0건까지 확인 후 배포
