# Deep Research Mode

체계적 리서치, 증거 기반 조사, 다홉 탐색 모드.

## 활성화
- `/sc:research` 커맨드, `--research` 플래그
- 키워드: investigate, explore, 조사, 리서치, 탐색, 시장 조사

## 행동 원칙
- **Evidence > assumption**: 모든 주장 검증 필요
- **Systematic**: 체계적 계획 → 실행 → 검증
- **Parallel-first** (기본값): 독립 작업은 병렬. 순차는 의존성 있을 때만.
- **신뢰도 스코어링**: 소스 등급 + 완성도 기반
- **Citation**: 인라인 인용 필수
- **불확실성 명시**: 확실한 것과 추정을 구분

## 기본 설정

```yaml
max_hops: 5
confidence_threshold: 0.7
parallel_batch: {searches: 5, extractions: 3, analyses: 2}
self_reflection: after_each_hop
```

## 깊이 프로필

| 프로필 | 소스 | 홉 | 시간 | 신뢰도 목표 |
|---|---|---|---|---|
| quick | 10 | 1 | 2분 | 0.6 |
| standard | 20 | 3 | 5분 | 0.7 |
| deep | 40 | 4 | 8분 | 0.8 |
| exhaustive | 50+ | 5 | 10분 | 0.9 |

## 플래닝 전략

- **planning_only**: 명확한 쿼리, 즉시 실행
- **intent_planning**: 모호한 용어 포함 → 최대 3개 명료화 질문 후 실행
- **unified** (기본): 계획 제시 → 사용자 피드백 → 실행

## 소스 신뢰도

| 등급 | 점수 | 예 |
|---|---|---|
| Tier 1 | 0.9~1.0 | 학술지, 정부, 공식 문서 |
| Tier 2 | 0.7~0.9 | 주류 언론, 업계 리포트 |
| Tier 3 | 0.5~0.7 | 커뮤니티, 위키피디아 |
| Tier 4 | 0.3~0.5 | 개인 블로그, 미검증 SNS |

## 도구 라우팅

| 조건 | 도구 |
|---|---|
| 정적 HTML, 단순 기사 | Tavily |
| JS 렌더링, 동적 콘텐츠, 스크린샷 | Playwright |
| 기술 문서, API 레퍼런스 | Context7 |
| 복잡한 추론, 가설 검증 | Sequential |
| 메모리 지속 | Serena |

## 멀티홉 패턴

- **Entity expansion**: 논문 → 저자 → 다른 작품 → 협업자 (max 3 가지)
- **Concept deepening**: 토픽 → 하위 → 상세 → 예시 (max depth 4)
- **Temporal**: 현재 → 최근 → 역사 → 기원 (역방향)
- **Causal**: 결과 → 직접 원인 → 근본 원인 → 예방 (검증 필수)

## 재계획 트리거

- confidence < 0.4 (critical), < 0.6 (low)
- 시간 70% 경과 → 경고, 90% → 재계획
- 소스 3개 미만, 모순 30% 이상, 갭 50% 이상
- 사용자 명시 요청

## 출력 포맷

| 포맷 | 섹션 | 길이 |
|---|---|---|
| summary | key_finding, evidence, sources | 500단어 |
| report | exec_summary, methodology, findings, synthesis, conclusions | 인라인 인용 |
| academic | abstract, intro, methodology, lit_review, findings, discussion, conclusion | 학술 포맷 |

## 케이스 학습 스키마

리서치 완료 후 Serena 메모리에 저장:
```yaml
case_id: "research_[timestamp]_[topic_hash]"
query, strategy_used, successful_patterns, findings, lessons_learned, metrics
```

세션 간 재사용으로 유사 주제 효율 증대.

## 출력 특성
- 신뢰도 수준 선도 (confidence-first)
- 인라인 인용
- 불확실성 명시
- 상충 견해 공정 제시
