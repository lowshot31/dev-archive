# 🚀 개발 프로젝트 포트폴리오

Salesforce CRM 프레임워크와 API 자동화 솔루션을 통합 설계하는 엔지니어입니다. 기술적 가능성을 비즈니스 임팩트로 치환하기 위해 구현과 배포 자동화에 집중하고 있습니다.

## 📂 프로젝트 목록

### 1. [🥛 Pre Dairy](./Pre_home)

**Pre Dairy B2B 셀프서비스 포털 (Salesforce 기반)**  
_2025.12 ~ 2026.01_

Salesforce CRM (Apex/LWC/SOQL) 인프라와 FastAPI를 연동하여 포털 시스템 및 고객 데이터 수집 시스템을 자동화한 프로젝트입니다. 비즈니스 로직(할당/배송 자동화)과 CRM 플랫폼 연동 경험을 담았습니다.

- **성과 중심 핵심 요약**:
  - **포털/고객 셀프서비스 (Experience Cloud)**: 고객이 직접 주문 현황 관리와 케이스 조회를 수행할 수 있도록 권한을 위임한 LWC(Lightning Web Components) 대시보드 포털 환경을 구축하여 B2B 셀프서비스 구조 확립.
  - **REST API 데이터 파이프라인 (Web-to-Lead/Case)**: 외부 파트너사 웹사이트(Python/FastAPI)에서 입력된 폼 데이터를 Salesforce로 적재하기 위해, HTML 인터페이스 속성(Class, Name)을 매핑하고 REST 당김 로직 구현.
  - **카카오 API + 자율 할당(Assignment Rule)**: 고객 위치 정보를 카카오 주소 API로 획득하고 가장 인접한 유치 대리점으로 기회를 분배하는 백엔드 프로세스 빌딩.
- **주요 기술**: Salesforce (Apex, SOQL, LWC, Experience Cloud), Python (FastAPI), REST API

[📖 상세 문서 확인 →](./project_.md)

---

### 2. [🤖 Crypto CS AI](./crypto-cs-ai)

**API 통합 전주기 워크플로우 자동화 엔진 (n8n & LLM 멀티라우팅)**  
*2026.03*

가상자산 고객 문의(CS) 단계에서 발생하는 수동적인 데이터 추출 및 대조 과정을 n8n 플랫폼, 로컬 LLM, 외부 온체인 오픈 API 망을 활용하여 완전 자동화 파이프라인으로 구축한 구조화 추출 AI 챗봇입니다.

- **성과 중심 핵심 요약**:
  - **수동 데이터 추출 프로세스 자동화**: 자연어에서 데이터 구조화 추출이 완료되면, 즉시 **Etherscan V2 API를 동적 호출(REST)**하여 결과를 Slack 운영 채널로 전송하는 로우 레이턴시 파이프라인 구축.
  - **환각(Hallucination) 방어 설계 체계화**: 단순 생성 챗봇이 아닌, 정규표현식(Regex) 검증 레이어, EVM 체인/비EVM 체인을 판별하는 동적 라우팅을 도입해 시스템 오작동 소스를 차단함.
  - **효율적 다중 로컬 모델 최적화**: Ollama 위에서 뉘앙스 파악용 자연어 모델(qwen3)과 구조화 추출 전담 모델(qwen2.5-coder) 두 개를 오케스트레이션하여 응답 안정성 확보.
- **주요 기술**: n8n, Ollama, Etherscan API, Slack Webhook, Docker Compose

[📖 상세 문서 확인 →](./crypto-cs-ai/README.md)

---

### 3. [🧠 Gstack-Antigravity AI Agent System](https://github.com/lowshot31/gstack-antigravity)

**프롬프트 튜닝 및 Google 에이전트 워크플로우 시스템 포팅**  
*2026.03*

Garry Tan의 'gstack' 에이전트 워크플로우 시스템을 분석하고, 이를 Google Antigravity 엔진 문법에 맞추어 변환, 맞춤형 워크플로우(office-hours, investigate 등) 룰셋을 새롭게 이식한 튜닝/설계 프로세스 경험입니다.

- **성과 중심 핵심 요약**:
  - **AI Agent 구조파악 및 역설계**: 복잡한 에이전트 작동 방식과 시스템 프롬프팅 구조를 해체하고, 명령어 기반 체인을 새 플랫폼에 안정적으로 빌드업.
  - **생산성 가속화 파이프라인 수립**: 코드 작업 전 브레인스토밍(/office-hours)부터 디버깅(/investigate)을 자율 행동 에이전트에 위임하는 설계 문서 자동화 체계 수립.
- **주요 기술**: Prompt Engineering, Agent Orchestration, Bash Script

---

### 4. [🤖 coinbot](./coinbot)

**업비트 암호화폐 급등 알림 텔레그램 봇**
<br>2025.08<br>
업비트 거래소의 실시간 시세를 모니터링하여 급등하는 코인을 텔레그램으로 알려주는 봇입니다.

- **주요 기능**: 실시간 KRW 마켓 모니터링, 급등 감지 알고리즘, 텔레그램 알림, 다중 사용자 지원
- **기술 스택**: Python, python-telegram-bot, asyncio, Upbit API
- **특징**: 비동기 처리, API 제한 준수, 실시간 제어

[📖 자세히 보기 →](./coinbot/README.md)

---

### 5. [🧭 Gidne](./gidne)

**투자 내비게이션 대시보드 - 실시간 금융 데이터 통합 플랫폼**
<br>2026.01~진행중<br>

복잡한 금융 데이터를 하나의 화면에서 실시간으로 제공하는 투자 의사결정 지원 대시보드입니다.

- **주요 기능**:
  - 실시간 글로벌 시장 지수 모니터링 (나스닥, S&P 500, 코스피)
  - 매크로 경제 지표 통합 (금리, 환율, 원자재, 물가)
  - 암호화폐 온체인 데이터 분석 (청산맵, 김치 프리미엄, 고래 거래)
  - 경제 일정 카운트다운 (FOMC, CPI 발표)
  - 상대 강도(RS) 기반 종목 필터링
- **기술 스택**:
  - Frontend: HTML5, CSS3, Vanilla JavaScript (Bento Grid UI)
  - Data Sources: Polygon.io, FRED, Finnhub, CryptoQuant, Coinglass
  - Integration: Websocket (실시간 스트리밍), REST API
  - Analytics: 순유동성 연산, RS Ratio, 변동성 괴리 분석
- **핵심 차별점**:
  - **Websocket First**: REST가 아닌 실시간 스트리밍 우선
  - **Data Synapse**: 매크로(FRED) + 주식(Polygon) + 크립토(CryptoQuant) 통합
  - **맥락 제공**: 나스닥 하락 → 비트코인 영향 자동 분석
  - **클린 UI**: Bento Grid 기반 모던 대시보드

[📖 자세히 보기 →](./gidne/Gidne_Product_Definition.md)

---

### 6. [🌐 Global_in](./Global_in)

**웹 크롤링 및 이커머스 플랫폼**
<br>2024.11~2025.02<br>
이커머스를 위한 데이터 수집 시스템과 실제 판매 플랫폼을 포함하는 통합 프로젝트입니다.

- **주요 기능**:
  - 웹 크롤링 (이마트, GS25, CU)
  - 카테고리 계층 구조 생성 및 DB 저장
  - Spring Boot 기반 이커머스 플랫폼
  - AWS 클라우드 통합 (S3, SQS, ECR)
- **기술 스택**:
  - Python, Pandas, Selenium, Oracle DB
  - Spring Boot 3.4, Java 17, Redis, WebSocket
  - AWS (S3, SQS, ECR), JSP + Bootstrap
- **하위 프로젝트**:
  - `project_crawling`: Python 웹 크롤링 및 데이터 처리
  - `Sell_Buy`: Spring Boot 이커머스 웹 애플리케이션

[📖 자세히 보기 →](./Global_in/README.md)

---

## 🛠️ 전체 기술 스택

### Languages

![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![Java](https://img.shields.io/badge/Java-007396?style=flat&logo=java&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)

### Frameworks & Libraries

- **Backend**: FastAPI, Spring Boot, Uvicorn
- **Frontend**: Lightning Web Components (LWC), JSP, Bootstrap
- **Data Processing**: Pandas, openpyxl
- **Automation**: Selenium, python-telegram-bot, asyncio
- **Infrastructure**: Terraform

### Cloud & Infra (Foundational)

- **Cloud Platform 기본 활용**: GCP (Cloud Run, Cloud Scheduler), AWS (S3 단일 객체 저장소)
- **CI/CD 및 환경**: GitHub Actions 기반 기초 배포, Docker
- **Monitoring 경험**: Datadog (Faker 연동 커스텀 메트릭 전송 테스트)

### Databases

- **Oracle Cloud Database**
- **Redis**
- **GCS (Google Cloud Storage)**

### CRM & Integration

- **Salesforce**:
  - Apex (30+ 클래스)
  - Lightning Web Components (15+ 컴포넌트)
  - Experience Cloud (커스텀 포털)
  - SOQL, Triggers
  - Web-to-Lead, Web-to-Case
- **Financial Data APIs**:
  - Polygon.io: 실시간 주식 시세
  - FRED (Federal Reserve): 매크로 경제 지표
  - Finnhub: 금리, 기업 실적
  - CryptoQuant: 온체인 데이터
  - Coinglass: 파생상품, 청산 데이터
- **Upbit API**: 암호화폐 시세 조회
- **Telegram Bot API**: 실시간 알림

---

## 📁 디렉토리 구조

```
.
├── Pre_home/                 # 유기농 유제품 홈페이지 (프론트엔드 - FastAPI)
├── Pre_Dev/                  # Salesforce CRM 백엔드 및 포털 (Apex/LWC)
├── crypto-cs-ai/             # 가상자산 고객 대응 워크플로우 자동화 (n8n/LLM)
├── gstack-antigravity/       # AI 에이전트 시스템 워크플로우 및 통합 룰셋
├── qwen-tts-integration/     # WSL2 로컬 모델 트러블슈팅 및 오디오 파이프라인
├── Global_in/                # 외부 벤더 웹 크롤링 및 카테고리 데이터 적재 (ETL)
├── coinbot/                  # 업비트 급등 알림 봇 (비동기 API)
├── gidne/                    # 투자 내비게이션 대시보드 (진행중)
├── multicloud-devsecops/     # GCP/Datadog 클라우드 인프라 모니터링 실습 (PoC)
├── project_.md               # Pre Dairy 프로젝트 통합 기술 명세 문서 (아키텍처/Q&A)
├── README.md                 # 포트폴리오 메인 문단 (본 파일)
└── RESUME_DRAFT.md           # 국문 이력서 초안
```

---

---

## 💡 솔루션의 가치

### 1. 엔드-투-엔드 비즈니스 자동화 (Pre Dairy 프로젝트)

**문제 해결**: 유기농 유제품 업체의 디지털 전환 및 고객 관리 자동화

- **프론트엔드/UI 개선** (Pre Dairy):
  - 카카오 주소 API 연동으로 **정확한 배송지 매핑** → 배송 오류 방지
  - 다중 제품 선택 UI 도입으로 **고객 견적 문의 UX 개선 및 이탈률 감소**
  - Glassmorphism 디자인으로 **프리미엄 브랜드 경험 제공**
- **백엔드 통합** (Pre_Dev):
  - **공정한 기회 배분**: '거리+업종' 기반 거리 계산 알고리즘(DISTANCE)으로 수동 리드 분배에 따른 **병목 해소 및 영업사원 단축 배정**
  - **고객 셀프서비스**: 포털 대시보드 구축으로 고객이 직접 주문/문의 조회 환경을 갖추어 **CS 운영 채널 부담 완화**
  - **물류 최적화**: 가장 인접한 유통 대리점 자동 연결 로직으로 결제부터 유통까지의 **파이프라인 결합**

**비즈니스 임팩트**:

- 외부 고객 유입부터 내부 배송망 연결까지 **엔드투엔드 파이프라인 수립**
- 영업 기회(Opportunity) 성공에 따른 Account 전환 시, **고객 위치 기반 최적 대리점 매핑 로직 구현**

---

### 2. 클라우드 모니터링 및 인프라 연동 (multicloud-devsecops PoC)

**학습 목표**: 클라우드 인프라(GCP) 상의 서버리스 구동 및 외부 모니터링 툴 연동 기초 습득

- **구현 내용**:
  - Python 기반 Faker 로직을 활용한 모의(Mock) 로그 제너레이터 스크립트 작성
  - Cloud Run (Jobs) + Cloud Scheduler를 결합하여 필요 시점에만 구동되도록 설정
  - 생성된 모의 서버 로그를 Datadog Log Management 커스텀 메트릭으로 전송/수집

**학습 임팩트**:

- 상시 구동(Always-on) 인스턴스 대신 유휴 리소스 비용을 절감하는 온디맨드(On-Demand) 개념 이해
- 외부 솔루션(Datadog)과의 연동을 통해 클라우드 파이프라인의 관측성(Observability) 기초 체득

---

### 3. 실시간 시장 기회 포착 (coinbot)

**문제 해결**: 24시간 암호화폐 시장 모니터링 불가능

- **핵심 기능**:
  - 업비트 API Rate Limit 준수 (비동기 처리)
  - 급등 패턴 감지 알고리즘 (설정 가능한 임계값)
  - 다중 사용자 텔레그램 봇

**비즈니스 임팩트**:

- **7일 24시간 자동 모니터링**
- 알림 지연 시간 1초 이내
- 실시간 알림을 통한 거래소 앱 의존도 탈피

---

### 4. 실시간 금융 데이터 통합 (Gidne)

**문제 해결**: 파편화된 금융 정보로 인한 투자 의사결정 지연

- **핵심 기능**:
  - **정보 통합**: 매크로(FRED) + 주식(Polygon) + 크립토(CryptoQuant)를 하나의 대시보드에 통합
  - **실시간 스트리밍**: Websocket 기반으로 지연 없는 시세 제공
  - **맥락 제공**: 나스닥 하락 → 비트코인 영향 자동 분석 (Data Synapse)
  - **상대 강도(RS) 필터링**: 지수 대비 초과 수익 종목 실시간 선별

**비즈니스 임팩트**:

- **다수 지표 조회 리소스 단축** (5-6개 사이트 순회 → 단일 대시보드 통합)
- **의사결정 속도 향상**: 실시간 데이터로 급변장 대응 시간 단축
- **맥락 기반 인사이트**: 거시경제 → 자산 가격 연쇄 반응 자동 감지

---

### 5. 이커머스 상품 데이터 적재 (Global_in)

**문제 해결**: 파편화된 외부 벤더의 상품 정보 수집 및 RDBMS 체계화

- **크롤링 및 적재 엔진**:
  - Selenium, Pandas를 활용해 이마트/GS25/CU 웹 채널 동시 상품 수집 및 Excel 기반 중간 데이터 정제 처리
  - 수집된 원시 데이터를 Oracle DB의 계층형 카테고리에 맞추어 파싱 후 자동 적재(Insert)
- **로컬 플랫폼 구동 (진행 중)**:
  - 수집된 DB 스키마를 바탕으로 Spring Boot 3.4 로컬 서버를 세팅하여 백엔드 데이터베이스 호출 구조 마련

**주요 성과**:

- Oracle DB와 Python(Pandas) 스크립트 간 이기종 시스템 대용량 데이터 적재(ETL) 경험 확보
- 프론트웹의 비정형 데이터를 RDBMS 테이블에 구조화하여 적재하는 백엔드 데이터 정제 경험 확보

---

## 🔗 연동 아키텍처

### 아키텍처 패턴별 분류

#### 1️⃣ **API 통합 아키텍처** (Pre Dairy + Pre-SFDX)

```
[사용자]
    ↓ (HTTPS)
[FastAPI 서버]
    ↓ Web-to-Lead
[Salesforce CRM]
    ↓ Apex Trigger
[거리 기반 자동 배정]
    ↓ LWC
[Experience Cloud 포털]
    ↓
[고객 셀프서비스]
```

**핵심 연동 포인트**:

- **FastAPI ↔ Salesforce**: Web-to-Lead (HTTP POST)
- **카카오 API ↔ Salesforce**: 주소 데이터 자동 매핑
- **Apex ↔ LWC**: 포털 데이터 실시간 동기화
- **Lightning ↔ ContentVersion**: 대용량 파일 업로드 처리

**기술적 챌린지 해결**:

- CORS 이슈: ngrok + SSL 인증서로 해결
- 주소 파싱: 카카오 API `sido`, `sigungu` 필드 활용
- 파일 업로드: Base64 인코딩 + 순차 업로드로 size limit 회피

---

#### 2️⃣ **실시간 스트리밍 아키텍처** (coinbot)

```
[Upbit WebSocket API]
    ↓ asyncio
[급등 감지 엔진]
    ↓
[필터링 로직]
    ↓ python-telegram-bot
[텔레그램 서버]
    ↓
[다중 사용자]
```

**핵심 연동 포인트**:

- **Upbit API ↔ Python**: REST + WebSocket 하이브리드 통신
- **asyncio ↔ Telegram**: 이벤트 루프를 활용한 비동기 메시지 전송
- **Rate Limiter ↔ API**: 초당 요청 제한(Limit) 방어

**기술적 챌린지 해결**:

- API Limit: asyncio.sleep + 자체 요청 큐 관리 구현
- 동시성: 비동기(async/await)를 통해 스레드 블로킹 문제 회피
- 안정성: 네트워크 타임아웃 예외 처리 + 자체 재연결 로직

---

#### 3️⃣ **데이터 파이프라인 (ETL) 연동** (Global_in)

```
[웹사이트 (이마트/GS25 등)]
    ↓ Selenium 크롤링
[Pandas 데이터 정제]
    ↓ Excel 1차 검증
[Oracle DB 계층형 적재]
    ↓ MyBatis/JPA
[Spring Boot 서버 연동]
```

- **Focus**: 프론트엔드 크롤링 데이터를 RDBMS(Oracle)의 테이블 정규화 구조에 적재하고, Spring 애플리케이션에서 이를 API로 꺼내 쓸 수 있도록 잇는 기초 백엔드 파이프라인 구현 경험.

---

#### 4️⃣ **다중 API 결합 운영 자동화 채널** (Crypto CS AI)

```
[자연어 입력] → [Ollama LLM (Intent / Regex Parsing)] 
                            ↓ 조건 분기점 (Router)
[Etherscan V2 온체인 조회] ↔ [n8n 엔진] → [Slack Webhook 알림]
```

- **Focus**: 단순 단일 스크립트를 넘어, 내부 정규표현식 검증, REST API 통신(Etherscan 연동), 슬랙 통합 알림까지 오작동 없이 흘러가도록 다중 워크플로우를 오케스트레이션.

---

## 🎯 핵심 역량

### 시스템 통합 역량

✅ **서드파티/플랫폼 연동**: Salesforce CRM 인프라 및 외부 오픈 API(Telegram, 온체인 등) 간의 데이터 흐름 확보  
✅ **API 인터페이스 활용**: 상황에 맞는 REST, WebSocket, Webhook 인터페이스 통신 설계  
✅ **비동기 처리**: 비동기(asyncio) 통신 및 트랜잭션 스케줄링을 통한 API 제한 준수 및 병목 완화  

### 문제 해결 중심 개발

✅ **비용/리소스 최적화**: 서버리스 아키텍처 및 온디맨드(On-demand) 접근을 통한 유휴 인프라 비용 절감  
✅ **비즈니스 로직 자동화**: 수작업(엑셀, 수동 배정) 의존도가 높은 업무 프로세스를 식별하여 파이프라인 시스템으로 전환  
✅ **시스템 안정성 방어**: 정규표현식(Regex) 기반 데이터 검증 및 예외 처리(Error Handling)로 시스템 오작동 차단  

### 기술 스택 및 베이스

✅ **프론트엔드**: Vanilla JS, LWC(Lightning Web Components) 기반 대시보드 및 경량 UI 구현  
✅ **백엔드/데이터**: FastAPI, Apex 중심의 서버 로직 구현 및 Pandas를 활용한 기초 데이터 정제 파이프라인  
✅ **클라우드/모니터링 (Basic)**: GCP/AWS 클라우드 환경 테스트 배포 및 Datadog 커스텀 메트릭 연동을 통한 모니터링 기초 경험

---

## 📞 연락처

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2025 Portfolio Projects**
