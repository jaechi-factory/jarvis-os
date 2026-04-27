---
name: 에이전트 실제 호출 의무 (Echo ≠ 실행)
description: L2/L3 에이전트를 실제로 호출하지 않고 "🧭 L1 → director → L3" 라우팅 표기만 하는 행위 금지. 변경 완료 후 사용자 확인 전 반드시 관련 리뷰 에이전트 실호출
type: feedback
originSessionId: 833b13e0-0bf8-4825-b29a-e1bd444c45fb
---
Echo 표기(`🧭 L1 → design-director → ui-designer`)만 하고 실제 Agent() 호출을 생략하는 것 금지.

**Why**: 2026-04-18 하루말씀 작업 중 사용자가 발견 — 내가 라우팅 표기만 해놓고 director/L3 실호출 없이 바로 Codex/Edit로 작업해왔음. 결과적으로 L2 검토층이 완전히 스킵되어 "완료 뱃지 중복", "플로팅 CTA의 당위성", "버튼 의미 불명확" 같은 이슈를 매번 사용자가 직접 잡다른 사용자야 했음. AGENTS_SYSTEM 섹션 9 "거짓 리포팅 금지"에 명백히 어긋나고, 사용자 시간 낭비.

**How to apply**:
- 변경(코드·디자인) 완료 후 사용자에게 결과 보여주기 전 **반드시** 관련 리뷰 에이전트 실호출
  - 코드: code-reviewer 또는 typescript-reviewer (qa-director 경유)
  - UI·시각: gui-critic (design-director 경유)
  - 보안: security-reviewer (qa-director 경유)
- Echo `🧭 L1 → <director> → <L3>` 표기는 **실제 Agent tool 호출이 뒤따를 때만** 사용
- 실호출 없으면 `🧭 L1 (direct · <사유>)` 로 정직하게 표기
- 토큰·속도 명분으로 에이전트 스킵 금지 — 사용자가 이슈 잡는 비용 > 에이전트 호출 비용
- director 호출 후 L3 피드백이 오면 **사용자에게 전달 전에** 수정할 것은 수정하고 남는 이슈만 리포트
