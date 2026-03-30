# gstack-antigravity

> Garry Tan의 [gstack](https://github.com/garrytan/gstack) 방법론을 **Google Antigravity** 에이전트에 맞게 변환한 워크플로우 & 규칙 세트.

gstack은 Claude Code를 가상 엔지니어링 팀으로 바꾸는 23개 슬래시 커맨드 시스템이다.
이 프로젝트는 그 중 Antigravity에서 작동하는 **핵심 7개 워크플로우 + 빌더 규칙**을 추출하여 변환한 것이다.

---

## 뭐가 들어있나

### 워크플로우 7개

| 커맨드 | 역할 | 원본 gstack |
|--------|------|-------------|
| `/office-hours` | 아이디어 브레인스토밍 & 검증 | `/office-hours` |
| `/plan-review` | CEO + Eng + Design 통합 리뷰 | `/plan-ceo-review` + `/plan-eng-review` + `/plan-design-review` |
| `/investigate` | 체계적 근본원인 디버깅 | `/investigate` |
| `/review` | Staff Engineer 수준 코드 리뷰 | `/review` |
| `/ship` | 테스트 → 커밋 → PR 생성 | `/ship` |
| `/retro` | 주간 회고 | `/retro` |
| `/security-audit` | OWASP + STRIDE 보안 감사 | `/cso` |

### 빌더 규칙

gstack의 3대 철학을 Antigravity `custom_rules.md`에 반영:

1. **Boil the Lake** — 완전한 구현이 숏컷보다 몇 분 더 걸리면, 완전한 걸 한다
2. **Search Before Building** — 3계층 지식 체계 (검증된 것 / 새로운 것 / 원리)  
3. **User Sovereignty** — AI는 추천, 사용자가 결정

추가로:
- **빌더 톤** — 직접적, 구체적, 파일명+라인 지목
- **완료 상태 프로토콜** — DONE / DONE_WITH_CONCERNS / BLOCKED / NEEDS_CONTEXT
- **3-Strike Rule** — 3번 실패하면 STOP하고 에스컬레이션

---

## 설치 방법

### 전제 조건
- [Antigravity](https://gemini.google.com/) 설치 완료
- Windows 환경 (macOS/Linux도 경로만 변경하면 동일)

### Step 1: 레포 클론

```bash
git clone https://github.com/<your-username>/gstack-antigravity.git
```

### Step 2: 워크플로우 복사

워크플로우 파일을 Antigravity의 `global_workflows` 디렉토리에 복사한다.

**Windows:**
```powershell
# 워크플로우 복사
Copy-Item -Path ".\workflows\*.md" -Destination "$env:USERPROFILE\.gemini\antigravity\global_workflows\" -Force

# 빌더 규칙 복사 (선택)
Copy-Item -Path ".\rules\custom_rules.md" -Destination "$env:USERPROFILE\.agent\custom_rules.md" -Force
```

**macOS/Linux:**
```bash
# 워크플로우 복사
cp workflows/*.md ~/.gemini/antigravity/global_workflows/

# 빌더 규칙 복사 (선택)
cp rules/custom_rules.md ~/.agent/custom_rules.md
```

### Step 3: 자동 설치 (PowerShell 원클릭)

```powershell
.\install.ps1
```

### Step 4: 확인

Antigravity를 재시작하면 새 워크플로우가 인식된다.
대화에서 `/office-hours`, `/investigate` 등을 입력하면 워크플로우가 실행된다.

---

## 사용법

### 새 아이디어를 검증할 때
```
/office-hours
```
스타트업 모드와 빌더 모드 중 선택. 6가지 질문으로 아이디어를 검증하고 설계 문서를 생성한다.

### 설계 리뷰가 필요할 때
```
/plan-review
```
CEO(범위), 엔지니어(아키텍처), 디자이너(UX) 세 관점에서 10점 만점으로 평가한다.

### 버그가 터졌을 때
```
/investigate
```
**철의 법칙:** 근본 원인 없이 수정 없음. 4단계 체계적 디버깅.

### 코드 리뷰
```
/review
```
BUG / ISSUE / NIT 분류. AUTO-FIX vs ASK 판단.

### PR 만들고 배포
```
/ship
```
Pre-flight 체크 → 테스트 → 커밋 정리 → PR 생성.

### 주간 회고
```
/retro
```
Git 통계 기반 자동 회고. 배포한 것, 배운 것, 다음 주 계획.

### 보안 점검
```
/security-audit
```
OWASP Top 10 + STRIDE 위협 모델. 확신도 8/10 이상만 보고.

---

## gstack과 차이점

| 항목 | gstack (Claude Code) | gstack-antigravity |
|------|---------------------|-------------------|
| 런타임 | Bun + Bash | Antigravity 네이티브 |
| 브라우저 | 자체 Playwright 데몬 | `browser_subagent` 사용 |
| 이미지 생성 | 없음 | `generate_image` 사용 |
| 텔레메트리 | Supabase 연동 | 없음 (로컬만) |
| Hook 시스템 | `PreToolUse` 훅 | 해당 없음 |
| /qa | 자체 브라우저 기반 | 미포함 (browser_subagent 직접 사용) |
| /codex | OpenAI Codex 연동 | 미포함 (단일 에이전트) |
| /browse | 컴파일된 바이너리 | 미포함 (browser_subagent 대체) |
| 언어 | 영어 | 한국어 |

---

## 커스터마이즈

### 워크플로우 수정
각 `.md` 파일을 직접 편집하면 된다. YAML frontmatter의 `description`은 Antigravity가 워크플로우 목록에 표시하는 텍스트다.

```yaml
---
description: 여기에 설명 작성
---
```

### 빌더 규칙 수정
`rules/custom_rules.md`를 편집하고 다시 복사하면 된다. 또는 직접 `~/.agent/custom_rules.md`를 수정해도 된다.

### 워크플로우 추가
`workflows/` 디렉토리에 새 `.md` 파일을 만들면 된다. 같은 형식을 따르면 Antigravity가 자동 인식한다.

---

## 기여

PR 환영. 특히:
- 새 워크플로우 추가
- 기존 워크플로우 개선
- 다른 에이전트(Cursor, Codex 등) 변환

---

## 크레딧

- [gstack](https://github.com/garrytan/gstack) by Garry Tan — 원본 방법론
- [Antigravity](https://gemini.google.com/) by Google DeepMind — 런타임 에이전트

---

## 라이선스

MIT License. gstack 원본과 동일.
