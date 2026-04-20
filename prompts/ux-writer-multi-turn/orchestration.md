# 멀티턴 오케스트레이션 가이드

3개 시스템 프롬프트(Turn 1/2/3)를 순차 호출해 단일 UX Writing 개선 결과를 얻는 흐름.

## 호출 순서

### 1. 입력 준비
- `trace_id` 발급 (UUID v4 권장)
- `payload` 조립 (service_profile, ui_context, writing_guidelines, text)
- `retry_count = 0` 초기화

### 2. Turn 1 호출 (진단)
```
input = {version:"v6-mt", trace_id, payload}
output_t1 = LLM(system=turn1-diagnose.md, user=JSON.stringify(input))
```
- JSON 파싱 실패 시 1회 재호출
- 2회 실패 시 `degraded: true` 반환하고 종료

### 3. Turn 2 호출 (개선)
```
t2_payload = {original_input: payload, diagnosis: output_t1}
output_t2 = LLM(
  system=turn2-improve.md,
  user=JSON.stringify({version, trace_id, payload: t2_payload})
)
```

### 4. Turn 3 호출 (검수)
```
t3_payload = {
  original_input: payload,
  diagnosis: output_t1,
  improvement: output_t2,
  retry_count
}
output_t3 = LLM(
  system=turn3-verify.md,
  user=JSON.stringify({version, trace_id, payload: t3_payload})
)
```

### 5. 분기 처리
- `overall == "pass"` → `output_t3.final_output` 반환 (종료)
- `overall == "fail"` && `retry_count < 2`
  - `retry_count++`
  - `output_t3.fix_hint`를 `t2_payload`에 주입
  - Turn 2 재호출 → Turn 3 재검수
- `retry_count >= 2` && 여전히 fail
  - `output_t3.degraded == true` 확인
  - `final_output` 그대로 반환 + 로그 경고

## 공통 처리

### 관측성
- 모든 호출에 동일 `trace_id` 유지
- 각 턴 I/O를 `trace_id` 키로 저장 (디버깅·회귀 테스트용)

### 추천 temperature
- Turn 1 (진단): 0.1 — 결정적 분류
- Turn 2 (개선): 0.5 — 후보 다양성 확보
- Turn 3 (검수): 0.1 — 결정적 판정

### 에러 복구
- JSON 파싱 에러는 **턴별 독립 재시도** (해당 턴만 1회 재호출)
- 3턴 전체 재시작 금지 (비용·지연 방지)

## 실패 모드 방어

### FM-1: Turn 1이 제안까지 출력
- **방어**: 출력 JSON에 `suggestion` 키 존재 시 reject → 재호출
- Turn 1 프롬프트가 "suggestion 생성 시 즉시 실패" 명시

### FM-2: Turn 2 후보 3개가 거의 동일
- **방어**: 후보 간 편집거리(Levenshtein) 30% 미만이면 temperature 0.9로 재생성

### FM-3: Turn 3 무한 fail 루프
- **방어**: `max_retry = 2` 강제, 초과 시 `degraded: true` + `final_output`에 현재 개선안 반환

## 단일 프롬프트(v6.1) 대비 장단점

**장점**
- 각 턴이 단순해져 LLM 성능 향상
- 디버깅 용이 (어느 턴이 실패했는지 특정)
- 진단·검수의 결정성(temperature 0.1) + 개선의 창의성(0.5) 분리

**단점**
- 3회 호출 → 비용·지연 3배
- 오케스트레이션 구현 필요
- 턴 간 핸드오프 스키마 관리 부담

## 언제 쓰나

- **v6.1 (단일 프롬프트)**: 일상 실무, 빠른 응답이 우선, 대부분의 케이스
- **멀티턴 v6-mt**: 고난도 케이스(복잡한 규칙 충돌·장문·법률 등), 디버깅 가능성이 중요한 경우, 품질이 비용보다 중요한 배치 작업
