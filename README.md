# 🚀 개발 프로젝트 포트폴리오

다양한 기술 스택을 활용한 개인 프로젝트 모음입니다.

## 📂 프로젝트 목록

### 1. [🥛 Pre](./Pre)

**유기농 유제품 회사 홈페이지 (프론트엔드)**
<br>2024.12~2025.01<br>

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
<br>2024.12~2025.01<br>

Pre 프로젝트의 Salesforce 백엔드로, Experience Cloud를 활용한 고객 포털 시스템입니다.

- **주요 기능**:
  - 고객 포털 대시보드 (주문, 케이스, 계약 관리)
  - 실시간 케이스 관리 및 파일 업로드
  - 거리 기반 리드 자동 배정 시스템
  - 배송 대리점 자동 연결 시스템
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

[📖 자세히 보기 →](./Pre-SFDX/README.md)

---

### 3. [🌐 Global_in](./Global_in)

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

### 4. [🤖 coinbot](./coinbot)

**업비트 암호화폐 급등 알림 텔레그램 봇**
<br>2025.08<br>
업비트 거래소의 실시간 시세를 모니터링하여 급등하는 코인을 텔레그램으로 알려주는 봇입니다.

- **주요 기능**: 실시간 KRW 마켓 모니터링, 급등 감지 알고리즘, 텔레그램 알림, 다중 사용자 지원
- **기술 스택**: Python, python-telegram-bot, asyncio, Upbit API
- **특징**: 비동기 처리, API 제한 준수, 실시간 제어

[📖 자세히 보기 →](./coinbot/README.md)

---

### 5. [☁️ multicloud-devsecops](./multicloud-devsecops)

**GCP 기반 멀티클라우드 DevSecOps 파이프라인**
<br>2025.09-10<br>

GCP Cloud Run Jobs, GitHub Actions, Terraform을 활용한 자동화된 데이터 파이프라인 및 DevSecOps 프로젝트입니다.

- **주요 기능**: 자동화된 로그 생성, 컨테이너화, 스케줄링 실행, Datadog 모니터링
- **기술 스택**: GCP (Cloud Run, Artifact Registry, Cloud Scheduler), Terraform, GitHub Actions, Datadog, Python
- **특징**: Workload Identity Federation, IaC, CI/CD 자동화, 비용 최적화 (99.7% 절감)

[📖 자세히 보기 →](./multicloud-devsecops/README.md)

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
├── multicloud-devsecops/   # GCP DevSecOps 파이프라인
│   ├── src/                # 소스 코드
│   ├── terraform/          # IaC 설정
│   └── docs/               # 프로젝트 문서
├── README.md               # 이 파일
└── RESUME_DRAFT.md         # 이력서 초안
```

---

## 🎯 프로젝트 특징

### 다양한 도메인 경험

- **웹 개발**: FastAPI, Spring Boot 기반 풀스택 웹 애플리케이션
- **CRM 개발**: Salesforce Experience Cloud, Apex, LWC
- **데이터 엔지니어링**: 웹 크롤링, 데이터 처리, DB 관리
- **DevOps**: CI/CD 파이프라인, IaC, 클라우드 인프라
- **자동화**: 텔레그램 봇, 스케줄링, 모니터링

### 클라우드 네이티브

- AWS 서비스 활용 (S3, SQS, ECR)
- GCP 서비스 활용 (Cloud Run, Artifact Registry, Cloud Scheduler)
- Terraform을 통한 Infrastructure as Code
- Workload Identity Federation을 통한 보안 강화

### 실용적인 문제 해결

- 비용 최적화 (월 $65 → $0.22, 99.7% 절감)
- API 제한 준수 (비동기 처리, Rate Limiting)
- 실시간 모니터링 및 알림 시스템

---

## 📞 연락처

프로젝트에 대한 문의나 협업 제안은 언제든 환영합니다!

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2025 Portfolio Projects**
