# Coinone 지원용 n8n 프로젝트 진행 정리 (2026-03-31)

## 프로젝트 목적

가상자산 거래소 CS 문의를 대상으로,
자연어 문의를 받아 PII 마스킹 후 문의 유형(intent)과 핵심 엔티티(coin, txid, network)를 추출하고,
유형별로 후속 처리 경로를 자동 분기한 뒤,
EVM/비EVM 체인 자동 판별, 온체인 API 조회, CS 팀 Slack 알림, 사용자 채팅 응답까지 연결하는 **n8n 기반 AI CS 챗봇 워크플로우**를 구축하는 것이 목표.

이 프로젝트는 코인원 JD의 다음 요구사항과 직접 연결된다.

- LLM 기반 AI Agent / 자동화 워크플로우 설계
- n8n 또는 유사 Low-Code 자동화 도구 경험
- LLM 활용 및 프롬프트 엔지니어링
- 데이터 구조화 추출 및 검증
- 외부 API 연동 기반 업무 자동화 구조 설계
- 블록체인/핀테크 도메인 이해

---

## 현재까지 구현된 워크플로우

현재 워크플로우 흐름:

`Chat Trigger (AI 챗봇 UI)`
→ `Edit Fields1 (raw_text = chatInput)`
→ `HTTP Request (Ollama/qwen3:8b 호출: PII 마스킹)`
→ `Edit Fields (masked 추출)`
→ `HTTP Request1 (Ollama/qwen2.5-coder:7b-instruct 호출: intent / coin / txid / network 구조화 추출)`
→ `Validate Extracted JSON (JSON parse + validation + network→chainId 매핑)`
→ `Switch (intent 기준 분기)`
├─ `deposit_delay`:
→ `Is EVM Chain?` (IF 분기)
├─ true: `Ethscan-Get Tx Receipt (동적 chainid)` → `Code in JavaScript` → `Slack CS Alert` → `Chat Response`
└─ false: `Non-EVM Triage` → `Slack Non-EVM Alert` → `Chat Response`
├─ `wrong_deposit`: `Wrong Deposit Triage` → `Slack Wrong Deposit` → `Chat Response`
└─ `other`: `Fallback Triage` → `Slack General Alert` → `Chat Response`

현재 의도 분기 값:

- `deposit_delay` (EVM) — Etherscan 멀티체인 온체인 조회 + action 결정 + Slack 알림 + 채팅 응답 ✅
- `deposit_delay` (비EVM) — manual_review 라우팅 + Slack 알림 + 채팅 응답 ✅
- `wrong_deposit` — triage + Slack 알림 + 채팅 응답 ✅
- `other` — fallback triage + Slack 알림 + 채팅 응답 ✅

---

## 이번 세션에서 완료한 작업

### 1) Request1 프롬프트 개선

기존 프롬프트는 출력 스키마만 지정하고 intent 분류 기준을 명확하게 설명하지 않아,
입금 지연 문의에서도 `other`로 분류될 가능성이 있었다.

이를 해결하기 위해 아래 기준을 프롬프트에 명시했다.

- `deposit_delay`: 사용자가 코인을 보냈지만 아직 거래소에 반영되지 않았다고 말하는 경우
- `wrong_deposit`: 잘못된 주소 / 네트워크 / 코인으로 입금한 경우
- `other`: 그 외 모든 경우
- `coin`: 명시된 경우에만 추출
- `txid`: `0x + 64 hex` 형식일 때만 추출

이를 통해 단순 JSON 반환이 아니라,
**분류 기준이 명시된 구조화 추출 프롬프트**로 개선했다.

---

### 2) 테스트 입력(raw_text) 시나리오 수정

초기 테스트 문장은 전화번호/이메일 마스킹 검증용 예시였기 때문에,
문의 의도 자체가 입금 지연이 아니어서 `other`로 분기되는 것이 정상 상태였다.

기존 예시:

```text
안녕하세요 제 번호는 010-1234-5678이고 이메일은 test@example.com 입니다.
```

입금 지연 시나리오 테스트를 위해 아래와 같이 입력을 수정했다.

```text
ETH를 입금했는데 아직 반영되지 않았습니다. txid는 0xc09ba72a9829431a89fddde287883dd6ee595fa615b126f51d6051befe65ddd8 입니다.
```

결과적으로 LLM이 다음과 같이 구조화 추출하도록 유도하는 데 성공했다.

```json
{
  "intent": "deposit_delay",
  "coin": "ETH",
  "txid": "0xc09ba72a9829431a89fddde287883dd6ee595fa615b126f51d6051befe65ddd8"
}
```

---

### 3) JSON parse + validation 로직 유지

기존 Code node는 그대로 유지했다.

구현 내용:

- `response` 문자열을 `JSON.parse()`로 변환
- 허용 intent 검증: `deposit_delay`, `wrong_deposit`, `other`
- `txid`가 존재할 경우 EVM hash 정규식 검증
  - `^0x[a-fA-F0-9]{64}$`
- `coin`이 문자열일 경우 대문자 정규화

이 로직 덕분에 LLM 출력 포맷 오류나 환각을 그대로 downstream에 넘기지 않도록 안전장치를 확보했다.

---

### 4) Switch 노드로 intent 기반 라우팅 확인

Switch 노드 기준값은 `intent`이며,
현재 다음 3개 브랜치로 분기되도록 설정되어 있다.

- `deposit_delay`
- `wrong_deposit`
- `other`

입금 지연 시나리오 문장을 사용한 결과,
실제로 `deposit_delay` 브랜치로 정상 분기되는 것을 확인했다.

---

### 5) Etherscan API 연동 성공

`deposit_delay` 브랜치 뒤에 HTTP Request 노드를 추가하여,
Etherscan V2 API를 통해 온체인 트랜잭션 상태를 조회하도록 구성했다.

사용한 엔드포인트:

```text
https://api.etherscan.io/v2/api
```

Query Parameters:

- `chainid = {{ $json.chainId }}` (동적 매핑 — Ethereum=1, BSC=56, Polygon=137 등)
- `module = transaction`
- `action = gettxreceiptstatus`
- `txhash = {{ $json.txid }}`
- `apikey = <ETHERSCAN_API_KEY>`

설명:

- `chainid`는 Validate Extracted JSON에서 network→chainId 자동 매핑된 값을 사용
- EVM 7개 체인(Ethereum, BSC, Polygon, Arbitrum, Optimism, Base, Avalanche) 지원

실행 결과 예시:

```json
{
  "status": "1",
  "message": "OK",
  "result": {
    "status": "1"
  }
}
```

의미:

- API 호출 성공
- 해당 tx hash 존재
- on-chain transaction success 확인

---

### 6) 온체인 결과 해석용 Code 노드 구현

Etherscan 응답을 그대로 두는 대신,
후속 업무 action으로 번역하는 Code 노드를 추가했다.

핵심 해석 로직:

- API 호출 실패 → `manual_review_api_error`
- receipt status = `1` → `review_exchange_crediting`
- receipt status = `0` → `manual_review_failed_tx`
- 그 외 → `pending_confirmation`

실제 실행 결과 (테스트 입력: `ETH를 입금했는데 아직 반영되지 않았습니다. txid는 0xc09ba72a...ddd8 입니다.`):

```json
[
  {
    "intent": "deposit_delay",
    "coin": "ETH",
    "txid": "0xc09ba72a9829431a89fddde287883dd6ee595fa615b126f51d6051befe65ddd8",
    "action": "review_exchange_crediting",
    "onchain_status": "confirmed_success",
    "api_status": "1",
    "api_message": "OK",
    "receipt_status": "1"
  }
]
```

이 단계에서 단순 기술 상태값이 아니라,
**온체인 조회 결과를 기반으로 후속 운영 액션을 결정하는 구조**로 발전시켰다.

---

## 현재까지 구현된 핵심 가치

### 1. LLM 기반 문의 구조화 추출

- 자연어 문의에서 intent / coin / txid를 구조화 추출
- 단순 분류가 아니라 실제 워크플로우 입력값으로 사용 가능

### 2. 룰 기반 검증으로 안정성 확보

- JSON parse
- intent whitelist
- txid regex validation
- coin normalization

즉, LLM 출력을 그대로 신뢰하지 않고 **후처리 검증 계층**을 둠.

### 3. intent 기반 자동 분기

- `deposit_delay`
- `wrong_deposit`
- `other`

문의 유형별 후속 처리 경로를 분리할 수 있는 구조 확보.

### 4. 외부 온체인 API 연동

- `deposit_delay` 브랜치에서 Etherscan API 호출
- 온체인 성공/실패 여부 확인 가능

### 5. 온체인 조회 기반 운영 액션 결정

- 단순 상태값이 아니라
  - `action` (후속 처리 방향)
  - `onchain_status` (온체인 확인 상태)
  - `receipt_status` (트랜잭션 성공/실패)
    형태로 운영팀이 즉시 판단할 수 있는 결과 생성

즉 이 프로젝트는 단순 데모가 아니라,
**문의 분류 → 검증 → 분기 → 외부 조회 → 운영 액션 추천 → CS 알림 → 사용자 응답**까지 연결되는 완전한 AI CS 워크플로우.

### 6. Task별 LLM 모델 분리 배치 (테스트 완료, 적용 확정)

- Ollama에 `qwen3:8b` (5.2GB), `qwen2.5-coder:7b-instruct` (4.7GB) 두 모델을 설치
- 각 단계의 특성에 따라 모델을 분리 배치:
  - **HTTP Request (PII 마스킹)** → `qwen3:8b` — 자연어 이해/뉘앙스 파악에 강점
  - **HTTP Request1 (구조화 추출)** → `qwen2.5-coder:7b-instruct` — JSON 출력 정확도 높고, `<think>` 태그 없이 깔끔한 출력
- 실제 테스트 결과 `qwen2.5-coder`는 thinking 없이 순수 JSON만 반환하여 파싱 안정성이 크게 향상됨
- Task 특성에 맞는 모델 선택으로 각 단계의 출력 정확도를 최적화하는 구조 확보

### 7. Slack Incoming Webhook 기반 CS 알림 파이프라인

- 모든 브랜치의 최종 출력을 Slack `#cs-deposit-alerts` 채널로 자동 전달
- 온체인 상태, 추천 액션, txid 등을 CS 운영 친화적 포맷으로 메시지 구성
- **입력 → 분석 → 판단 → 외부 조회 → CS 팀 알림**까지 end-to-end 파이프라인 완성

### 8. EVM/비EVM 멀티체인 자동 판별 및 동적 라우팅

- LLM 추출 결과의 `network` 필드 + `coin` 기반 네트워크 보정 로직으로 체인 자동 판별
- EVM 7개 체인: Etherscan V2 API로 동적 `chainid` 매핑 후 온체인 조회
- 비EVM 8개 체인(BTC, XRP, SOL, DOGE, ADA, DOT, ATOM, TRX): IF 분기로 manual_review 라우팅

### 9. Chat Trigger 기반 AI 챗봇 인터페이스

- Manual Trigger → Chat Trigger로 전환하여 n8n 내장 채팅 UI 활용
- 사용자가 채팅으로 CS 문의 입력 → 워크플로우 처리 → 채팅으로 응답 반환
- Slack 알림과 사용자 응답이 동시에 동작하는 양방향 구조

### 10. 프로덕션급 인프라 구성

- Docker Compose 기반: n8n + PostgreSQL + Ollama 컨테이너 오케스트레이션
- PostgreSQL을 n8n 백엔드 DB로 사용하여 워크플로우 정의, 실행 이력, 채팅 세션 데이터 영속화
- SQLite 기본값 대신 PostgreSQL을 선택하여 프로덕션 환경과 동일한 구성 확보

---

## 현재 프로젝트 상태 요약

한 줄 요약:

**“LLM 기반 문의 구조화 추출, 검증, intent 분기, Etherscan 기반 온체인 조회, 후속 action 추천까지 연결된 n8n 기반 Crypto CS workflow를 구현한 상태”**

모든 브랜치가 **채팅 입력 → PII 마스킹 → 분석 → 판단 → 외부 조회 → CS Slack 알림 → 사용자 응답 반환**까지 완전한 end-to-end로 동작한다.

---

## 향후 확장 가능 영역 (선택)

- 비EVM 체인별 전용 API 연동 (Blockstream for BTC, Solscan for SOL 등)
- Google Sheets 또는 PostgreSQL 직접 연동을 통한 CS 케이스 감사 로그 구현
- downstream CRM/티켓 시스템 연동 설계 (Zendesk, Salesforce 등)
- 다국어 CS 문의 지원 (영어/일본어 등)
- RAG 기반 FAQ 자동 응답 확장

---

## 이력서 / 포트폴리오에 쓸 수 있는 문장 예시

- **n8n 기반 Crypto CS AI 챗봇을 설계하여, 자연어 CS 문의에서 intent/asset/txid/network를 구조화 추출하고 온체인 상태 조회 후 Slack 채널 자동 알림 + 사용자 채팅 응답까지 연결되는 end-to-end 프로토타입을 구현**
- **LLM 출력에 대해 JSON parsing, whitelist validation, regex 검증을 적용해 안정성을 확보하고, Etherscan V2 API와 연동해 EVM 멀티체인(ETH/BSC/Polygon/Arbitrum 등 7개) deposit delay 케이스의 운영 triage 자동화 구조를 설계**
- **Task 특성에 따라 LLM 모델을 분리 배치(자연어 처리: qwen3:8b, 구조화 추출: qwen2.5-coder:7b-instruct)하여 각 단계의 출력 정확도와 파싱 안정성을 최적화**
- **EVM/비EVM 체인 자동 판별 및 분기 처리 — EVM 체인은 Etherscan 온체인 조회, 비EVM 체인은 manual review 라우팅으로 동적 분기**
- **Slack Incoming Webhook을 통해 온체인 조회 결과와 후속 액션을 CS 운영 채널에 실시간 자동 전달하는 알림 파이프라인 구현**
- **Docker Compose 기반 프로덕션급 인프라 구성(n8n + PostgreSQL + Ollama) 및 Chat Trigger를 통한 AI 챗봇 인터페이스 구현**

---

## 참고

- 현재 EVM 7개 체인(Ethereum, BSC, Polygon, Arbitrum, Optimism, Base, Avalanche)에 대해 Etherscan V2 API 기반 동적 chainid 매핑 및 온체인 조회 지원
- 비EVM 체인(BTC, XRP, SOL, DOGE, ADA, DOT, ATOM, TRX)은 coin 기반 네트워크 보정 로직으로 자동 판별하여 manual_review로 라우팅
- 향후 비EVM 체인별 전용 API(Blockstream, Solscan 등) 연동으로 확장 가능
