---
name: 플러그인 업데이트 알림 강제 표시
description: SessionStart hook이 inject한 plugin update 알림은 자비스 응답 첫 줄에 무조건 노출. 깜빡 방지.
type: feedback
---

# 플러그인 업데이트 알림 강제 표시 룰

자비스 응답 시작 시 컨텍스트에 **"🔔 Plugin Update Notification"** 또는 **"━━━ 🔔 Plugin Update 알림"** 텍스트가 보이면, **응답 첫 줄에 무조건 알림 배너를 출력**한다. 사용자 메시지 답변보다 먼저 표시.

**Why**: SessionStart hook의 stdout이 자비스 컨텍스트에 inject되더라도, 자비스가 다른 작업·긴 컨텍스트에 집중하면 알림 언급 깜빡할 수 있음. 사용자가 plugin update 발생 사실을 100% 인지해야 매핑 재조정·재시작 같은 후속 작업이 누락 안 됨.

**How to apply**:

1. **트리거**: 자비스 turn 시작 시 컨텍스트에 다음 패턴 중 하나라도 있으면:
   - `━━━ 🔔 Plugin Update 알림`
   - `# 🔔 Plugin Update Notification`
   - `Plugin Update Notification`

2. **출력**: 사용자 답변 시작 전 첫 줄에:
   ```
   🔔 [Plugin Update 알림] N개 플러그인 자동 업데이트됨 (재시작 후 적용)
   ━━━ 변경 내역 ━━━
   - <plugin> updated from <old> to <new>
   - ...
   ━━━━━━━━━━━━━━━━━
   매핑 재조정 검토 필요 시 알려주세요.
   ```

3. **그 다음** 사용자가 원래 물은 질문에 대한 답변 진행

4. **반복 방지**: 같은 알림이 여러 turn 컨텍스트에 남아있어도 첫 turn에만 출력. 두 번째 turn부터는 자비스 자율 판단(사용자가 묻지 않으면 다시 안 띄움)

**표기 형식 예시**:

```
🔔 [Plugin Update 알림] 2개 플러그인 자동 업데이트됨 (재시작 후 적용)
━━━ 변경 내역 ━━━
- claude-mem updated from 11.0.1 to 12.4.9
- compound-engineering updated from 2.62.1 to 3.3.2
━━━━━━━━━━━━━━━━━
매핑 재조정 검토할까요?

(이하 사용자 원래 질문에 대한 답변)
```

**관련 메모리**:
- [`reference_plugin_auto_update.md`](reference_plugin_auto_update.md) — 자동 갱신 메커니즘 셋업
- 동작: SessionStart hook → notifications/*.md → stdout inject → 이 룰이 첫 줄 강제 표시
