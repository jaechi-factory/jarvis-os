---
name: DESIGN.md 컨벤션
description: Google Stitch가 제안한 AI 에이전트용 디자인 시스템 마크다운. UI 일관성 SSOT.
type: reference
originSessionId: 064d95cf-eb75-4881-9de4-c51c4be9b9b9
---
**DESIGN.md**: Google Stitch가 제안한 개념. AI 코딩 에이전트가 읽고 일관된 UI를 생성하도록 하는 순수 마크다운 디자인 시스템 문서. Figma export/JSON 스키마 대체.

**짝**: AGENTS.md(빌드 방법) ⇄ DESIGN.md(시각 규칙). 프로젝트 루트에 둠.

**표준 9개 섹션**:
1. Visual Theme & Atmosphere
2. Color Palette & Roles (의미적 역할 포함)
3. Typography Rules
4. Component Stylings (상태별)
5. Layout Principles
6. Depth & Elevation
7. Do's and Don'ts
8. Responsive Behavior
9. Agent Prompt Guide

**참고**: github.com/VoltAgent/awesome-design-md

**적용된 에이전트** (2026-04-12):
- ui-designer: 작업 시작 시 DESIGN.md 우선 읽기. 없으면 9개 섹션으로 초안 작성 → 사용자 승인
- gui-critic: benchmark/adapt/critique 3모드 모두 DESIGN.md 기준선으로 사용
- gan-generator: UI 코드 작성 전 필수 참조. 충돌 시 에드혹 값 금지, DESIGN.md 확장 후 반영
