# 🚀 개발 프로젝트 포트폴리오

Salesforce CRM 프레임워크와 API 자동화 솔루션을 통합 설계하는 엔지니어입니다. 기술적 가능성을 비즈니스 임팩트로 치환하기 위해 구현과 배포 자동화에 집중하고 있습니다.

## 📂 프로젝트 목록

### 1. [☁️ Pre & Pre-SFDX](./Pre-SFDX)

**Salesforce 환경 기반 B2B 셀프서비스 포털 구축 및 연동 자동화 전략**  
*2025.12 ~ 2026.01*

Salesforce CRM (Apex/LWC/SOQL) 인프라와 FastAPI를 연동하여 포털 시스템 및 고객 데이터 수집 시스템을 자동화한 프로젝트입니다. 비즈니스 로직(할당/배송 자동화)과 CRM 플랫폼 연동 경험을 담았습니다.

- **성과 중심 핵심 요약**: 
  - **포털/고객 셀프서비스 (Experience Cloud)**: 고객이 직접 주문 현황 관리와 케이스 조회를 수행할 수 있도록 권한을 위임한 LWC(Lightning Web Components) 대시보드 포털 환경을 구축하여 B2B 셀프서비스 구조 확립.
  - **REST API 데이터 파이프라인 (Web-to-Lead/Case)**: 외부 홈페이지(FastAPI) 고객 문의 폼(Form)의 입력을 Salesforce에 실시간 Lead/Case로 생성하도록 REST 통신 연동.
  - **카카오 API + 자율 할당(Assignment Rule)**: 고객 위치 정보를 카카오 주소 API로 획득하고 가장 인접한 유치 대리점으로 기회를 분배하는 백엔드 프로세스 빌딩.
- **주요 기술**: Salesforce (Apex, SOQL, LWC, Experience Cloud), Python (FastAPI), REST API 

[📖 상세 문서 확인 →](./Pre-SFDX/README.md)

---

### 2. [🤖 Crypto CS AI](./crypto-cs-ai)

**API 통합 전주기 워크플로우 자동화 엔진 (n8n & LLM 멀티라우팅)**  
*2026.03*

가상자산 고객 문의(CS) 단계에서 발행하는 수동적인 분석/동기화 작업을 n8n 플랫폼, 로컬 LLM, 외부 온체인 오픈 API 망을 활용하여 완전 자동화 파이프라인으로 구축한 구조화 추출 AI 챗봇입니다.

- **성과 중심 핵심 요약**:
  - **Etherscan V2 API & Slack 통합**: 자연어에서 파싱 된 트랜잭션 값을 Etherscan REST API를 거쳐 실시간 온체인 결과를 도출하고, 그에 따른 운영 가이드를 Slack으로 즉각 전송해 워크플로우를 자동화.
  - **환각(Hallucination) 방어 설계 체계화**: 단순 생성 챗봇이 아닌, 정규표현식(Regex) 검증, JSON Validation, EVM 체인/비EVM 체인을 갈라내는 "동적 라우팅"을 도입해 시스템 안정성을 높임.
  - **효율적 다중 로컬 모델 최적화**: Ollama 위에서 뉘앙스 파악용 자연어 모델(qwen3)과 구조화 추출용 모델(qwen2.5-coder) 두 개를 오케스트레이션 설계.
- **주요 기술**: n8n, Ollama, Etherscan API, Slack Webhook 연동, Postgres, Docker Compose

[📖 상세 문서 확인 →](./crypto-cs-ai/README.md)

---

### 3. [🧠 Gstack-Antigravity AI Agent System](https://github.com/lowshot31/)

**프롬프트 튜닝 및 Google 에이전트 워크플로우 포팅 프로젝트**  
*2026.03*

Claude Code 기반으로 작성된 Garry Tan의 'gstack' 에이전트 시스템을 분석하고, 이를 Google Antigravity 엔진에 맞도록 변환, 맞춤형 워크플로우(office-hours, investigate 등) 룰셋을 새롭게 이식한 튜닝/설계 프로세스 경험입니다.

- **성과 중심 핵심 요약**:
  - **AI Agent 구조파악 및 역설계**: 복잡한 에이전트 작동 방식과 시스템 프롬프팅 구조를 해체하고, 워크플로우(명령어 기반 체인)를 새 플랫폼에 안정적으로 빌드업.
  - **생산성(Developer Experience) 가속화**: 코드 작업 전 브레인스토밍(/office-hours)부터 디버깅(/investigate), 서버 취약점 분석 과정 등을 자율 행동 에이전트에 위임하는 설계 문서 체계화 방식 수립.
- **주요 기술**: Prompt Engineering, Agent Orchestration, Python/Bash Environment

---

### 4. 기타 기본기 및 데이터 파이프라인 경험 (Summary)

- **[Global_in eCommerce 백엔드 파이프라인](./Global_in)** *(2024.11-2025.02)*  
  : 대규모 상품 스크래핑(Python Selenium) 데이터를 백엔드 데이터베이스로 이관하는 **ETL 파이프라인 구현**. (Java/Spring Boot, Oracle DB, Redis, WebSocket)
- **[multicloud-devsecops 모니터링](./multicloud-devsecops)** *(2025.09-10)*  
  : GCP (Cloud Run, Scheduler) 및 Terraform 기반 인프라 배포 자동화, Workload Identity를 활용하여 보안을 높이고 CI/CD(Github Actions)부터 **Datadog 실시간 로그 연동** 파이프라인 검증 시뮬레이션.
- **[Gidne 실시간 데이터 대시보드](./gidne)** *(2026.01)*  
  : FRED(매크로 지표), Polygon.io(주식), CryptoQuant(암호화폐) 등 복잡한 API 데이터 소스들을 통합하여 인사이트를 모니터링하는 Bento Grid 대시보드 구조화.

---

## 🔗 핵심 연동 파이프라인 구조도

### [핵심 1. B2B 고객 포털 & API 자동화 아키텍처 (Pre-SFDX)]
```text
[홈페이지 문의 폼(FastAPI POST)] → (Web-to-Lead/Case) → [Salesforce CRM] 
                                                        ↓ (Apex Trigger & Logic)
[Experience Cloud 포털 연동] ← (LWC Data Sync) ← [거리 기반 영업 할당 시스템]
```
- **Focus**: ngrok / CORS 처리 및 외부 REST 채널과 세일즈포스 생태계 실시간 연동. Experience Cloud UI를 거쳐 CS 비용을 축소한 B2B SaaS 환경을 구현.

### [핵심 2. 다중 API 결합 운영 자동화 파이프라인 (Crypto CS AI)]
```text
[CS 자연어 입력] → [Ollama LLM (Intent/JSON Regex Parsing)] 
                                ↓ (Intent Switch/Router)
[Etherscan V2 API 조회] ↔ [n8n Automation Engine] → [Slack Webhook 자동 결재]
```
- **Focus**: 단순 대화를 넘어 검증된 API 통신(Etherscan)을 경유하여 비즈니스 가치(액션) 판단, 슬랙 알림까지 End-to-End 오케스트레이션 자동화.

---

## 🎯 커리어 핵심 역량

### 데이터/시스템 통합 전문성 (Integration)
✅ **멀티 플랫폼 API 연결망 설계**: Salesforce, Slack, Etherscan, n8n, GCP  
✅ **비즈니스 아키텍처**: REST API 동적 파싱, webhook 활용 통합  
✅ **AI 에이전트 시스템 튜닝**: 시스템 프롬프팅 및 LLM 파이프라인 라우팅

### 프레임워크 및 기반 지식
✅ **백엔드/데이터베이스**: Java (Spring Boot), Python (FastAPI/Asyncio), Oracle, MySQL  
✅ **CRM 도메인 지식**: Salesforce (Apex, SOQL, LWC, Experience Cloud) 플랫폼 아키텍처  
✅ **인프라/모니터링**: Terraform, Docker, Datadog 연동 

---

## 📞 연락처

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2026 Portfolio Projects**
