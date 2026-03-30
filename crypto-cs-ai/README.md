# 🤖 Crypto CS AI - 전주기 API 통합 및 워크플로우 자동화 엔진

**n8n 기반 멀티-에이전트 CS 분류 및 외부 온체인 API 통합 챗봇**  
<br>2026.03 (1인 프로젝트)<br>

단순한 자연어 입력을 받아, 온체인 트랜잭션을 동적으로 조회하고 지원 운영팀에게 실시간 슬랙 알림을 전송하는 **End-to-End 완전 자동화 파이프라인** 모델입니다.

## 🎯 프로젝트 목적 및 해결 과제

가상자산 거래소(예: Coinone)의 고객 문의(CS) 단계에서 발행하는 수동적인 데이터 추출 및 대조 과정을 AI 에이전트와 외부 API로 대체하여 운영 비용과 응답 지연을 획기적으로 낮춥니다.
LLM의 환각(Hallucination)을 제어하기 위해 룰 기반 검증 레이어와 듀얼 모델을 도입했습니다.

## 🚀 워크플로우 흐름 아키텍처

```mermaid
graph TD
    A[Chat Trigger] --> B(PII 마스킹<br>Ollama: qwen3)
    B --> C(구조화 데이터 추출<br>Ollama: qwen2.5-coder)
    C --> D{JSON & Regex<br>Validator}
    D --> E{의도(Intent) 기반<br>라우팅}
    E -->|deposit_delay| F{EVM 여부 판별}
    F -->|EVM 체인| G[Etherscan V2 API 조회]
    F -->|비-EVM 체인| H[수동 리뷰 전환]
    G --> I(운영 액션 판단 Code)
    I --> J[CS Slack 자동 채널 발송]
    H --> J
    E -->|wrong_deposit| K[오입금 전담 채널 알림] --> J
```

## ✨ 주요 기능 및 구현 성과

### 1. REST API 통합을 통한 워크플로우 자동화

채팅 입력에서 추출된 `txid`, `network` 데이터를 이용해 **Etherscan V2 REST API**를 호출, 실시간 트랜잭션 상태(성공, 실패, 펜딩)를 서버리스 없이 워크플로우 단일 파이프라인에서 동적으로 조회합니다.

### 2. LLM 로컬 분리 배치 체계화

기능 특성에 맞추어 **Ollama** 에 로컬 모델 2개를 배포하여 병목과 실패율을 방어했습니다.

- **qwen3:8b**: 자연어 뉘앙스 이해, PII (개인정보) 마스킹 처리
- **qwen2.5-coder:7b-instruct**: 데이터 구조화 (JSON Regex 추출) 전담 (Thinking 모델 제거로 파싱 에러 방어)

### 3. EVM / 비EVM 동적 라우팅 및 검증 절차 (Validation)

추출된 `coin`과 `network` 필드를 이용해 동적으로 EVM / 비EVM 여부를 판별하여, 비EVM일 경우 `manual_review` 로 라우팅하여 시스템 오작동을 차단합니다.
추가적으로 추출 후 `JSON.parse` 및 Regex (`^0x[a-f0-9]{64}$`) 룰을 활용해 AI 데이터가 완전히 검증된 상태로만 하단 프로세스로 흐르게 설계했습니다.

### 4. Slack WebHook 기반 운영팀 액션 알림

도출 결과를 기반으로 단순 조회가 아닌 "후속 처리 방향(action)", "온체인 상태(onchain_status)"등 운영팀이 직관적으로 판단할 수 있는 가공 데이터를 Slack 채널로 발행해 알림 시간을 1초 이내로 단축시켰습니다.

## 🛠 기술 스택

- **Automation AI Tool**: n8n
- **LLM Engine**: Ollama (qwen3, qwen2.5-coder)
- **Database & Infra**: PostgreSQL, Docker, Docker Compose
- **Intergration API**: Etherscan V2 API, Slack Incoming Webhook, Regex, Javascript(Node)

## 💡 Key Learnings

이 파이프라인의 설계 경험은 단순한 CS 대응이 아니라, 외부 REST 통신 규격과 비즈니스 로직(라우팅, 분기, 알림)을 유기적으로 결합하여 세일즈포스나 여타의 CRM 엔진 상에 그대로 연동시킬 수 있는 **통합 자동화 (System Integration)** 의 토대가 되었습니다.
