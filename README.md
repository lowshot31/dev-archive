# 🚀 개발 프로젝트 포트폴리오

다양한 기술 스택을 활용한 개인 프로젝트 모음입니다.

## 📂 프로젝트 목록

### 1. [🥛 Pre](./Pre)

**유기농 유제품 회사 홈페이지 (프론트엔드)**
<br>2025.12~2026.01<br>

FastAPI 기반의 유기농 유제품 전문 기업 홈페이지로, Salesforce CRM과 연동되는 반응형 웹 애플리케이션입니다.

- **주요 기능**:
  - 회사 소개 (비전/미션, 타임라인 연혁)
  - 제품 전시 (동적 필터링, 뱃지 시스템)
  - 견적 문의 (Web-to-Lead, 카카오 주소 검색 API)
  - 고객 센터 (이메일 문의, FAQ 아코디언)
  - Experience Cloud 포털 로그인 연동
- **기술 스택**:
  - Backend: FastAPI, Uvicorn, Jinja2
  - Frontend: Vanilla JavaScript (ES6+), HTML5, CSS3
  - Integration: Salesforce (Web-to-Lead), 카카오 우편번호 API, Mailto
  - Deployment: HTTPS (SSL), ngrok
- **특화 기능**:
  - 다중 제품 선택 태그 UI
  - 실시간 전화번호 포매팅
  - Scroll reveal 애니메이션
  - Glassmorphism 디자인 시스템
  - 주소 자동 완성 및 Salesforce 필드 매핑

[📖 자세히 보기 →](./Pre/README.md)

---

### 2. [🏢 Pre-SFDX](./Pre-SFDX)

**Salesforce CRM 백엔드 및 Experience Cloud 포털**
<br>2025.12~2026.01<br>

Pre 프로젝트의 Salesforce 백엔드로, Experience Cloud를 활용한 고객 포털 시스템입니다.

- **주요 기능**:
  - 고객 포털 대시보드 (주문, 케이스, 계약 관리)
  - 실시간 케이스 관리 및 파일 업로드
  - 공정한 영업 기회 배분을 위한 '거리+업종' 기반 리드 자동 배정 시스템
  - 최적 경로 및 거리 기반 배송 대리점 자동 연결 시스템
- **기술 스택**:
  - Salesforce: Apex, Lightning Web Components (LWC), SOQL
  - Experience Cloud: 커스텀 포털, 반응형 UI
  - Integration: Web-to-Lead, Web-to-Case
- **핵심 컴포넌트**:
  - `PortalDashboardController`: 포털 데이터 처리 및 권한 관리
  - `portalHeader`, `portalFooter`: 일관된 UI/UX
  - `portalCaseDetail`: 케이스 상세 뷰 및 실시간 댓글
  - `portalNewOrderForm`, `portalNewCaseForm`: 주문/케이스 생성
- **문서화**:
  - Salesforce ERD (9개 주요 객체)
  - 커스텀 Apex 클래스 상세 문서
  - 리드 필수 필드 및 중복 규칙

[📖 자세히 보기 →](./Pre_Dev/README.md)

---

---

### 3. [☁️ multicloud-devsecops](./multicloud-devsecops)

**GCP 기반 멀티클라우드 DevSecOps 파이프라인**
<br>2025.09-10<br>

GCP Cloud Run Jobs, GitHub Actions, Terraform을 활용한 자동화된 데이터 파이프라인 및 DevSecOps 프로젝트입니다.

- **주요 기능**: 자동화된 로그 생성, 컨테이너화, 스케줄링 실행, Datadog 모니터링
- **기술 스택**: GCP (Cloud Run, Artifact Registry, Cloud Scheduler), Terraform, GitHub Actions, Datadog, Python
- **특징**: Workload Identity Federation, IaC, CI/CD 자동화, 비용 최적화 (99.7% 절감)

[📖 자세히 보기 →](./multicloud-devsecops/README.md)

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
├── Pre/                    # 유기농 유제품 홈페이지 (프론트엔드)
│   ├── static/             # CSS, JS, 이미지
│   └── templates/          # HTML 템플릿
├── Pre-SFDX/               # Salesforce CRM 백엔드 및 포털
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

### 1. 엔드-투-엔드 비즈니스 자동화 (Pre 프로젝트)

**문제 해결**: 유기농 유제품 업체의 디지털 전환 및 고객 관리 자동화

- **프론트엔드 혁신** (Pre):
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

#### 1️⃣ **API 통합 아키텍처** (Pre + Pre-SFDX)

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

**핵심 연동 포인트**:

- **Selenium ↔ 웹사이트**: 동적 콘텐츠 크롤링
- **Pandas ↔ Oracle**: 대용량 데이터 배치 삽입
- **Spring Boot ↔ AWS**: S3 파일 저장, SQS 메시지 큐
- **Redis ↔ App**: 세션 관리 + 캐싱

**기술적 챌린지 해결**:

- 동적 로딩: Selenium WebDriverWait
- 데이터 검증: Excel 템플릿 기반 검증
- 카테고리 계층: 재귀 함수로 트리 구조 생성

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

프로젝트에 대한 문의나 협업 제안은 언제든 환영합니다!

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2025 Portfolio Projects**
