---
description: OWASP Top 10 + STRIDE 위협 모델 기반 보안 감사. "보안 검사", "취약점 확인", "security audit" 할 때 사용.
---

# /security-audit — 보안 감사

제로 노이즈 원칙. 확신도 8/10 이상의 발견만 보고. 모든 발견에 구체적 공격 시나리오 포함.

---

## Step 1: 코드베이스 스캔

### 1.1: 어택 서피스 매핑
**에이전트 지시:** 내장된 `grep_search` 도구를 사용하여 다음 패턴을 찾으세요. (터미널 명령어를 직접 실행하지 마세요.)

1. **API 엔드포인트 찾기:**
   - 정규식 패턴: `app\.(get|post|put|delete|patch)` 또는 `@(Get|Post|Put|Delete|Patch)` 또는 `router\.(get|post|put|delete)`
2. **환경변수 사용:**
   - 정규식 패턴: `process\.env|os\.environ|env\.`
3. **시크릿/키 하드코딩 패턴:**
   - 정규식 패턴: `(?i)(password|secret|api_key|token|private_key)`

---

## Step 2: OWASP Top 10 체크

| # | 카테고리 | 체크 항목 | 상태 |
|---|----------|-----------|------|
| A01 | 접근 제어 실패 | RBAC, 권한 검증, IDOR | ? |
| A02 | 암호화 실패 | HTTPS, 해싱, 키 관리 | ? |
| A03 | 인젝션 | SQL, NoSQL, OS 명령어, XSS | ? |
| A04 | 불안전한 설계 | 위협 모델링, 비즈니스 로직 | ? |
| A05 | 보안 설정 오류 | CORS, 헤더, 기본값 | ? |
| A06 | 취약 컴포넌트 | 의존성 버전, CVE | ? |
| A07 | 인증 실패 | 세션 관리, 비밀번호 정책 | ? |
| A08 | 데이터 무결성 | 역직렬화, CI/CD 파이프라인 | ? |
| A09 | 로깅/모니터링 실패 | 감사 로그, 알림 | ? |
| A10 | SSRF | 서버 사이드 요청 위조 | ? |

---

## Step 3: STRIDE 위협 모델

각 컴포넌트에 대해:

| 위협 | 질문 | 완화 조치 |
|------|------|-----------|
| **S**poofing (위장) | 인증 우회 가능? | ? |
| **T**ampering (변조) | 데이터 변조 가능? | ? |
| **R**epudiation (부인) | 행동 추적 가능? | ? |
| **I**nfo Disclosure (정보 유출) | 민감 데이터 노출? | ? |
| **D**enial of Service (서비스 거부) | 리소스 소진 가능? | ? |
| **E**levation (권한 상승) | 권한 상승 가능? | ? |

---

## Step 4: 의존성 보안

**에이전트 지시:** 프로젝트에 맞는 패키지 매니저 보안 검사를 실행하세요. 사용자의 환경에 맞는 터미널 명령어를 사용하세요.

#### 🪟 Windows (PowerShell)
```powershell
# Node.js
npm audit; $null

# Python
pip audit; $null
safety check; $null
```

#### 🍎 macOS / 🐧 Linux (Bash)
```bash
# Node.js
npm audit 2>/dev/null || true

# Python
pip audit 2>/dev/null || true
safety check 2>/dev/null || true
```

---

## Step 5: 보안 리포트

### False Positive 필터 (노이즈 제거)
보고하지 않는 것:
- 개발 전용 코드의 하드코딩된 값
- 테스트 파일의 테스트 시크릿
- .env.example의 플레이스홀더
- node_modules 내부 코드

### 리포트 형식

```
╔═══════════════════════════════════════════╗
║         SECURITY AUDIT REPORT             ║
╠═══════════════════════════════════════════╣
║ 스캔 범위:   N개 파일                      ║
║ 발견:        🔴 N개 / 🟡 N개 / 🟢 N개     ║
╠═══════════════════════════════════════════╣

🔴 HIGH — [제목]
  파일:     path/to/file.ts:42
  공격:     [구체적 공격 시나리오]
  수정:     [구체적 수정 방법]
  확신도:   9/10

🟡 MEDIUM — [제목]
  파일:     path/to/file.ts:88
  공격:     [구체적 공격 시나리오]
  수정:     [구체적 수정 방법]
  확신도:   8/10

╠═══════════════════════════════════════════╣
║ 종합 판정: PASS / NEEDS_FIX / CRITICAL    ║
╚═══════════════════════════════════════════╝
```

- **PASS** — 🔴 HIGH 0개
- **NEEDS_FIX** — 🔴 HIGH 존재하지만 즉시 공격 불가
- **CRITICAL** — 즉시 공격 가능한 취약점 존재
