---
name: UX Writer 에이전트 & 커맨드
description: 한국어 UI 문구 교정용. ux-writer 에이전트 + /ux-write, /ux-wash 슬래시 커맨드 전역 등록됨
type: reference
originSessionId: 4a40aa27-02f0-4e7f-b05d-c810c7c4ac87
---
# UX Writer 도구 세트

모든 프로젝트에서 한국어 UI 문구 교정에 사용.

## 리소스

- **에이전트**: `ux-writer` — `~/.claude/agents/ux-writer.md`
- **커맨드**:
  - `/ux-write` — 개별 문구 즉석 교정
  - `/ux-wash` — 프로젝트 전체 UI 문구 일괄 워싱 (--dry-run / --apply)
- **프롬프트 SSOT**: `~/.claude/prompts/ux-writer.md` — **ver 1.0 (2026-04-20 Founder 정의)**, GAN 라운드 6 평균 88.0/100 도달 안
- **단일 SSOT**: `~/.claude/prompts/ux-writer.md` ver 1.0 단독 보존. 옛 GAN 라운드(v6.1, v6-mt 멀티턴 4파일 등)는 ben 명시 지시로 2026-04-25 모두 삭제. 복구 필요 시 git history 의존

## 언제 사용

- UI 문구(버튼·토스트·에러·빈상태·온보딩·본문) 교정 요청이 들어오면 `/ux-write` 먼저 떠올릴 것
- 기존 프로젝트의 한국어 UI 전반을 점검하자는 요청이면 `/ux-wash --dry-run` 제안
- 번역투·부자연스러운 한국어·톤 불일치 지적이 들어오면 ux-writer 에이전트 자동 호출 고려

## ⚠️ MANDATORY — 작업 시작 전 필수 단계

이 메모리를 읽었다면 **즉시** 아래를 실행할 것:

```
Read(~/.claude/prompts/ux-writer.md)
```

포인터(이 파일)만 읽고 실제 spec 없이 문구를 수정하거나 제안하는 것은 금지.
spec에는 content_type별 글자 수 제한, 번역투 사전, brand_voice 프로파일, 전환 레버 4종, Self-Critique 6단계, 규칙 충돌 우선순위 등 작업에 직접 필요한 규격이 있음.

## 핵심 규격

- **content_type 10종**: button / toast / error / empty_state / onboarding / body / tooltip / dialog_title / banner_headline / cta_link
- **번역투 사전 14쌍** + 동형 패턴 (이중피동, 자동화 능동 전환, 명사형 묶음 등)
- **brand_voice 프로파일**: 서비스별 톤 매칭 (formal/casual/friendly/authoritative 등)
- **전환 레버 4종**: urgency / scarcity / social_proof / loss_aversion (각 alternative에 명시)
- **per-alternative axis**: frame / order / subject / length (length 남용 방지 가드)
- **critique_flags closed enum**: 4종 (translation_smell / brand_mismatch / length_violation / specificity_gap)
- **규칙 충돌 우선순위**: max_length > content_type 매트릭스 > guidelines > tone
- **출력**: suggestion / character_count / violations_fixed[] / applied_rules[] / reason(2문장+[태그]) / alternatives[2개 + use_when + axis + lever] / confidence(숫자 단일값)

## 성능 (GAN 라운드 6 측정값)

- 7-에이전트 평가: 평균 88.0/100 (78~94 분포)
- 6축 100점 루브릭: 결정성(15) / 커버리지(20) / 자동화 가능성(15) / 번역투·감도(15) / 컨버전 효과성(20) / 운영 안정성(15)
- v8.1로 추가 개선 시도 → 82.14로 회귀(brand_alignment 자체모순 등) → SSOT는 v8.0 안으로 고정 (2026-04-20 Founder 승인)

## 운영 원칙

- 프롬프트 SSOT 파일(`ux-writer.md`)을 직접 수정하지 말 것. 개선 필요 시 새 후보 → GAN 평가 → 합격 시에만 교체
- 아카이브 버전(v6.1~v8.1)은 절대 수정·이름 변경 금지 (히스토리 보존)
- 새 GAN 라운드는 pm-director + gan-planner/generator/evaluator 체인으로만 진행

## 버전 명명 규칙 (2026-04-20 Founder 정의)

- **파일명 고정**: 항상 `ux-writer.md` 한 개. 파일명에 ver 표기 금지 ("깔끔한 이름" 원칙)
- **내부 버전**: 파일 헤더 `# 한국어 UX Writing 프롬프트 — ver X.Y` 라인으로만 표기
- **현재**: ver 1.0 (= 구 v8.0 안)
- **차기**:
  - patch (+0.1): GAN 평가 통과한 부분 보강 (예시 추가, 번역투 사전 확장 등)
  - major (+1.0): 스키마·매트릭스·핵심 절차의 구조 변경
- **롤백 정책**: ver X.Y가 실측 회귀 시 즉시 직전 ver로 in-place 복원. 아카이브에서 가져옴
