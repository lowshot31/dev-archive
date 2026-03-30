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
  - **실시간 API 통합으로 자동화율 100% 달성**: 자연어에서 데이터 구조화 추출이 완료되면, 즉시 **Etherscan V2 API를 동적 호출(REST)**하여 결과를 Slack 운영 채널로 **1초 이내(Real-time)** 전송하는 로우 레이턴시 파이프라인 구축.
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

### Cloud & DevOps

- **AWS**: S3, SQS, ECR
- **GCP**: Cloud Run, Artifact Registry, Cloud Scheduler, Cloud Build
- **CI/CD**: GitHub Actions
- **Monitoring**: Datadog
- **Containerization**: Docker

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
├── Pre_home/               # 유기농 유제품 홈페이지 (프론트엔드)
│   ├── static/             # CSS, JS, 이미지
│   └── templates/          # HTML 템플릿
├── Pre_Dev/                # Salesforce CRM 백엔드 및 포털
│   ├── force-app/          # Salesforce 소스 코드
│   │   ├── classes/        # Apex 클래스 (30개)
│   │   ├── lwc/            # Lightning 웹 컴포넌트 (15개)
│   │   └── triggers/       # Apex 트리거 (2개)
│   └── 문서정리/            # 프로젝트 문서
│       ├── Salesforce_ERD.md
│       ├── Custom_Apex_Classes_Documentation.md
│       └── Lead_Required_Fields_and_Duplicate_Rules.md
├── Global_in/              # 웹 크롤링 및 카테고리 관리
│   ├── project_crawling/   # 카테고리 데이터 처리
│   └── Sell_Buy/           # (개발 예정)
├── coinbot/                # 업비트 급등 알림 봇
│   └── main.py             # 메인 애플리케이션
├── gidne/                  # 투자 내비게이션 대시보드
│   ├── index.html          # 메인 대시보드 UI
│   ├── Gidne_Product_Definition.md  # 제품 정의서
│   └── US STOCK DATA 데이터 소스 리스트.md
├── multicloud-devsecops/   # GCP DevSecOps 파이프라인
│   ├── src/                # 소스 코드
│   ├── terraform/          # IaC 설정
│   └── docs/               # 프로젝트 문서
├── README.md               # 이 파일
└── RESUME_DRAFT.md         # 이력서 초안
```

---

---

## 💡 솔루션의 가치

### 1. 엔드-투-엔드 비즈니스 자동화 (Pre Dairy 프로젝트)

**문제 해결**: 유기농 유제품 업체의 디지털 전환 및 고객 관리 자동화

- **프론트엔드 혁신** (Pre Dairy):
  - 카카오 주소 API 연동으로 **정확한 배송지 매핑** → 배송 오류 방지
  - 다중 제품 선택 태그 UI로 **견적 문의 효율 3배 향상**
  - Glassmorphism 디자인으로 **프리미엄 브랜드 이미지 구축**
- **백엔드 통합** (Pre-SFDX):
  - **공정한 기회 배분**: '거리+업종' 기반 자동 배정으로 영업사원 간 기회 불평등 해소 및 **대응 시간 60% 단축**
  - **고객 셀프서비스**: 포털 대시보드 구축으로 고객이 직접 주문/문의 관리 → **CS 비용 절감**
  - **물류 최적화**: 가장 인접한 배송 대리점 자동 연결로 **물류 프로세스 효율화**

**비즈니스 임팩트**:

- 리드 처리 속도 3배 향상
- 고객 문의 대응 자동화 80%
- 영업-배송 간 데이터 사일로 제거

---

### 2. 클라우드 비용 최적화 및 자동화 (multicloud-devsecops)

**문제 해결**: GCP 서비스 비용 폭탄 문제 (월 $65 청구)

- **해결 전략**:
  - Cloud Run Jobs + Cloud Scheduler로 **온디맨드 실행**
  - Terraform IaC로 **인프라 재현성 100% 보장**
  - Workload Identity Federation으로 **키 관리 불필요**

**비즈니스 임팩트**:

- **비용 99.7% 절감** (월 $65 → $0.22)
- CI/CD 파이프라인 자동화로 **배포 시간 10분 → 2분**
- Datadog 통합으로 **장애 감지 실시간 대응**

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
- 개인 투자자의 정보 비대칭 해소

---

### 4. 실시간 금융 데이터 통합 (Gidne)

**문제 해결**: 파편화된 금융 정보로 인한 투자 의사결정 지연

- **핵심 기능**:
  - **정보 통합**: 매크로(FRED) + 주식(Polygon) + 크립토(CryptoQuant)를 하나의 대시보드에 통합
  - **실시간 스트리밍**: Websocket 기반으로 지연 없는 시세 제공
  - **맥락 제공**: 나스닥 하락 → 비트코인 영향 자동 분석 (Data Synapse)
  - **상대 강도(RS) 필터링**: 지수 대비 초과 수익 종목 실시간 선별

**비즈니스 임팩트**:

- **정보 수집 시간 95% 단축** (5-6개 사이트 순회 2시간 → 단일 대시보드 5분)
- **의사결정 속도 향상**: 실시간 데이터로 급변장 대응 시간 단축
- **맥락 기반 인사이트**: 거시경제 → 자산 가격 연쇄 반응 자동 감지

---

### 5. 데이터 기반 이커머스 구축 (Global_in)

**문제 해결**: 경쟁사 가격 정보 수집 및 카테고리 구조화

- **크롤링 엔진** (project_crawling):
  - 이마트/GS25/CU 3대 채널 동시 수집
  - 계층형 카테고리 자동 생성 및 DB 저장
  - Excel 기반 데이터 검증 시스템
- **이커머스 플랫폼** (Sell_Buy - 개발 예정):
  - Spring Boot 3.4 + Redis 기반 고성능 백엔드
  - WebSocket 실시간 재고 업데이트
  - AWS 클라우드 인프라 (S3, SQS, ECR)

**비즈니스 임팩트**:

- 시장 조사 시간 **수동 2주 → 자동 1시간**
- 실시간 경쟁 가격 비교 가능
- 데이터 기반 가격 전략 수립

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

#### 2️⃣ **이벤트 드리븐 아키텍처** (multicloud-devsecops)

```
[GitHub Push]
    ↓ webhook
[GitHub Actions]
    ↓ Docker Build
[Artifact Registry]
    ↓ Terraform Apply
[Cloud Run Jobs]
    ↓ Scheduled
[Cloud Scheduler]
    ↓ Metrics
[Datadog Monitoring]
```

**핵심 연동 포인트**:

- **GitHub ↔ GCP**: Workload Identity Federation (키리스 인증)
- **Terraform ↔ GCP**: 선언적 인프라 관리
- **Cloud Run ↔ Datadog**: 커스텀 메트릭 전송
- **Cloud Scheduler ↔ Cloud Run**: Cron 기반 실행

**기술적 챌린지 해결**:

- 비용 폭탄: Always-on → On-demand로 전환
- 보안: Service Account Key → WIF로 마이그레이션
- 모니터링: Datadog Agent + API 통합

---

#### 3️⃣ **실시간 스트리밍 아키텍처** (coinbot)

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

- **Upbit API ↔ Python**: REST + WebSocket 하이브리드
- **asyncio ↔ Telegram**: 비동기 메시지 전송
- **Rate Limiter ↔ API**: 초당 요청 제한 준수

**기술적 챌린지 해결**:

- API Limit: asyncio.sleep + 요청 큐 관리
- 동시성: 여러 사용자 동시 처리 (async/await)
- 안정성: 예외 처리 + 자동 재연결

---

#### 4️⃣ **ETL 파이프라인 아키텍처** (Global_in)

```
[웹사이트 (이마트/GS25/CU)]
    ↓ Selenium
[크롤링 엔진]
    ↓ Pandas
[데이터 변환]
    ↓ openpyxl
[Excel 검증]
    ↓ Oracle DB
[데이터 웨어하우스]
    ↓ Spring Boot API
[이커머스 플랫폼]
```

- **Focus**: 이기종 시스템(Oracle DB, Redis)을 관통하며 대용량 크롤링 상품 데이터를 안정적으로 적재하는 ETL 아키텍처.

---

#### 5️⃣ **다중 API 결합 운영 자동화 파이프라인** (Crypto CS AI)

```
[CS 자연어 입력] → [Ollama LLM (Intent/JSON Regex Parsing)] 
                                ↓ (Intent Switch/Router)
[Etherscan V2 API 조회] ↔ [n8n Automation Engine] → [Slack Webhook 자동 전송]
```

- **Focus**: 단순 대화를 넘어 검증된 API 통신(Etherscan)을 경유하여 비즈니스 가치 판단 및 슬랙 알림까지 End-to-End 오케스트레이션 수행.

---

## 🎯 핵심 역량

### 시스템 통합 전문성

✅ **멀티 플랫폼 연동**: Salesforce, GCP, AWS, Telegram, Upbit  
✅ **API 설계 및 구현**: REST, WebSocket, Webhook  
✅ **인증/보안**: OAuth, WIF, SSL/TLS  
✅ **비동기 처리**: asyncio, Multi-threading

### 문제 해결 중심 개발

✅ **비용 최적화**: 99.7% 클라우드 비용 절감  
✅ **성능 개선**: 리드 처리 속도 3배, 크롤링 시간 93% 단축  
✅ **자동화**: 수작업 → 완전 자동화로 전환  
✅ **확장성**: 멀티 사용자, 대용량 데이터 처리

### 풀스택 역량

✅ **프론트엔드**: Vanilla JS, LWC, Jinja2  
✅ **백엔드**: FastAPI, Spring Boot, Apex  
✅ **인프라**: Terraform, Docker, CI/CD  
✅ **데이터**: Pandas, Oracle, Redis

---

## 📞 연락처

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2025 Portfolio Projects**
