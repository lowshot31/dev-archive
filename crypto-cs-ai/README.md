# 🤖 Crypto CS — 거래소 CS 자동화 파이프라인

> 로컬 LLM(Ollama) + Etherscan 자동 검증으로 크립토 거래소 CS 문의를 자동 분류/처리하는 n8n 워크플로우

## 핵심 흐름

```
사용자 채팅 → PII 마스킹 → LLM 의도 분류 → 온체인 검증 → Slack 티켓 → 자동 응답
```

## 기능

### 의도 분류 (3분기)
| Intent | 설명 | 처리 |
|--------|------|------|
| `deposit_delay` | 입금 지연 | EVM: Etherscan 자동 검증 / Non-EVM: 수동 triage |
| `wrong_deposit` | 오입금 | 수동 복구 검토 에스컬레이션 |
| `other` | 기타 문의 | CS 에이전트 수동 처리 |

### 지원 체인
- **EVM (7개)**: Ethereum, BSC, Polygon, Arbitrum, Optimism, Base, Avalanche
- **Non-EVM**: Bitcoin, Solana, XRP, Dogecoin, Cardano, Polkadot, Cosmos, Tron

### 핵심 검증 로직
- txid 형식 자동 감지 (EVM 0x... / Base58 / Hex64)
- coin 기반 네트워크 자동 보정 (BTC → bitcoin, SOL → solana)
- LLM 오분류 방어 (intent 보정, txid 폴백)
- PII 마스킹 (이메일, 전화번호)

## 기술 스택

| 구성요소 | 기술 |
|----------|------|
| 오케스트레이터 | n8n (self-hosted, Docker) |
| LLM | Ollama + qwen2.5-coder:7b-instruct |
| 온체인 검증 | Etherscan API v2 (멀티체인) |
| 알림 | Slack Block Kit (Interactive Messages) |

## 설치

### 사전 요구사항
- Docker + Docker Compose
- n8n (self-hosted)
- Ollama (qwen2.5-coder:7b-instruct 모델)
- Slack Bot Token
- Etherscan API Key

### 셋업

1. **n8n에 워크플로우 임포트**
   ```
   n8n > Settings > Import from File > My workflow(1).json
   ```

2. **환경변수 설정** (n8n credentials 또는 env)
   ```
   SLACK_BOT_TOKEN=xoxb-your-token
   ETHERSCAN_API_KEY=your-key
   SLACK_CS_CHANNEL=your-channel-id
   SLACK_SIGNING_SECRET=your-signing-secret
   ```

3. **Ollama 모델 다운로드**
   ```bash
   ollama pull qwen2.5-coder:7b-instruct
   ```

4. **Slack App 설정**
   - Bot Token Scopes: `chat:write`, `chat:update`
   - Interactivity: Webhook URL을 n8n webhook 경로로 설정

## 아키텍처

```
Pipeline 1: CS 문의 처리
[Chat] → [PII Mask] → [Extract Txid] → [Ollama LLM] → [Validate JSON]
    → [Switch] → deposit_delay → [EVM?] → [Etherscan] → [Slack Alert]
                → wrong_deposit → [Slack Alert]
                → other → [Fallback] → [Slack Alert]
    → [Chat Response]

Pipeline 2: Slack 버튼 액션
[Webhook] → [Parse Action] → [Switch] → Resolve/Escalate/Assign → [chat.update]
```

## 문서

프로젝트 문서는 `/docs` 폴더에 정리되어 있습니다:

| 문서 | 내용 |
|------|------|
| [아키텍처 & 데이터 흐름](docs/아키텍처-데이터-흐름.md) | Mermaid 다이어그램, 데이터 변환 흐름 |
| [노드 인벤토리](docs/노드-인벤토리.md) | 22개 노드 상세 |
| [검증 로직 상세](docs/검증-로직-상세.md) | 10단계 검증 파이프라인 |
| [테스트 케이스](docs/테스트-케이스-매트릭스.md) | 32개 테스트 시나리오 |
| [코드 리뷰](docs/코드-리뷰.md) | BUG 4, ISSUE 5, NIT 4 |
| [보안 감사](docs/보안-감사.md) | 시크릿 관리, Webhook 인증 |
| [백로그 & 로드맵](docs/백로그-로드맵.md) | P0-P3 액션 아이템 |

## 라이선스

MIT
