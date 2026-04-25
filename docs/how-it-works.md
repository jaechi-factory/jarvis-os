# JARVIS-OS 동작 원리

> 자비스가 어떻게 알아서 일하는지, 한눈에.

## 1. 5단 조직도 (Org Layer)

```
[Founder] = 사용자 (당신, 인간)         ← 최종 의사결정. 자비스랑만 대화
   │
[L1] = main Claude · CEO · "자비스"      ← 위임범위 자율. 다 종합해서 보고
   │
[L2] = C-Level 임원 6명                  ← 도메인 허브 (CPO·CDO·CTO·QA·CGO·PM)
   │
[L3] = Leader 32명                       ← 직군 리더 (자율 판단·다단계 실행)
   │
[L4] = Worker 218명 (스킬)               ← 템플릿·SOP 단위 작업
```

회사 비유로 생각하면 됨:
- **Founder=당신** = 최종 결정권자
- **CEO=자비스** = 일상 운영 자율, 큰 결정만 보고
- **L2 임원들** = 도메인별 책임자
- **L3 리더 / L4 워커** = 실무자

자비스는 당신 요청을 받으면 **자동으로 적절한 L2/L3 호출** → 결과 종합 → 5블록 리포트로 보고.

## 2. 5블록 리포트 (Visibility Layer)

위임이 발생하면 자비스가 자동으로 출력:

```
🧭 [라우팅 Echo]   ← 누가 누구를 호출했는지
📋 [지시 체인]    ← 누가 누구한테 뭘 시켰는지
⚙️ [실행 결과]    ← 각자 뭘 했는지
🔍 [상위 검토]    ← 누가 검토했고 어떻게 반영됐는지
✅ [L1 최종]      ← 자비스 최종 판단 + 다음 단계
```

→ Founder는 자비스랑만 대화하지만 **밑에서 누가 뭘 했는지 한 화면에** 보임.

## 3. Audit Log + 자동 푸터 (Audit Layer)

모든 도구 호출이 자동 기록:
```
~/.claude/audit/YYYY-MM-DD.jsonl
```

매 응답 끝에 자동 푸터 출력:
```
━━━ 도구 호출 트레이스 ━━━
이번 턴: Agent×2 Edit×3 Bash×4
  ↳ Agents: code-reviewer, ui-designer
세션 누적: ...
━━━━━━━━━━━━━━━━━━━━━━━━━━
```

→ "**자비스가 진짜 일했는지**" 자동 검증 가능. Echo와 audit log가 일치해야 진실 보고.

수동 검증 명령:
- `/trace` — 오늘 도구 호출 요약
- `/trace verify` — 마지막 5블록 Echo와 audit log 매칭 검증

## 4. 자동 정합성 검사 (Self-Healing Layer)

`/check-rules` 16개 자동 검사:

1. 역할 모델 호칭 (CEO=자비스 통일)
2. L3/L4 카운트
3. 카탈로그 버전 정합성
4. 5블록 SSOT
5. ABSOLUTE 위치
6. Audit hook 등록
7. Hook 실행권한
8. MEMORY 1줄 룰 (200자)
9. 자비스 호칭 등록
10. rules/common 분산
11. 트리거 키워드 누적
12. global frontmatter
13. SSOT 참조 정합성
14. 메모리 인덱스 등재
15. 충돌 진단 Tier1 적용
16. (확장 가능)

**룰 파일 변경 시 자동 발동** — 응답 끝에 검사 결과 자동 출력.

## 5. ABSOLUTE 룰 (정체성 Layer)

오버라이드 불가능한 최상위 룰:

### 역할 모델
- Founder=사용자, CEO=자비스(L1), 나머지 위임받은 범위 자율
- 비가역(커밋·머지·배포) / 정체성 / 예산 → Founder 명시 승인 필수

### 소통 3축
1. **정보 양질 최대** — 디테일·근거·트레이드오프 그대로
2. **누구나 이해 가능** — 전문 용어 풀이, 영어 약어 한국어 우선
3. **존중 구어체** — `~예요/~거든요` 친근하게

## 6. 트리거 자동 라우팅

키워드만 던지면 자비스가 자동으로 적절한 도구 호출:

| 사용자 키워드 | 자동 호출 |
|---|---|
| "디자인", "UI", "문구" | CDO + ui-designer / gui-critic |
| "버그", "코드", "성능" | CTO + code-reviewer / build-error-resolver |
| "라이브러리 사용법" | context7 MCP |
| "PRD 써줘" | `/write-prd` |
| "북극성 지표" | `/north-star` |
| "자비스, 룰 점검" | `/check-rules` |

→ 사용자가 외울 거 없음. 자비스가 알아서 매칭.

## 7. 충돌 방지 룰

같은 영역에 도구 여러 개 매칭되는 경우 (예: "리뷰" 키워드 → 4개 도구) **1순위 결정 자동 적용**:

- 코드 리뷰 4중: TS는 typescript-reviewer / 일반은 code-reviewer / 디버깅은 silent-failure-hunter / 대규모는 ce-review
- 리서치 5중: 라이브러리는 context7 / 웹은 Tavily / 코드베이스는 repo-research
- 브레인스톰 4중: 모호한 요구는 --brainstorm / 신규 제품은 pm-product-discovery / 코드 결정은 superpowers

세부: `~/.claude/projects/<slug>/memory/global/feedback_agent_skill_conflicts.md`

## 결론

JARVIS-OS는 **사용자가 외울 거 0개**가 목표예요. 자비스가:
- 알아서 라우팅
- 알아서 검증
- 알아서 백업
- 알아서 보고

사용자는 그냥 "**자비스, ~ 해줘**" 하면 끝.
