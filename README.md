# 🚀 개발 프로젝트 포트폴리오

다양한 기술 스택을 활용한 개인 프로젝트 모음입니다.

## 📂 프로젝트 목록

### 1. [🌐 Global_in](./Global_in)
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

### 2. [🥛 Pre](./Pre)
**유기농 유제품 회사 홈페이지**
<br>2025.12.10~2025.01<br>

FastAPI 기반의 유기농 유제품 전문 기업 홈페이지로, Salesforce CRM과 연동됩니다.

- **주요 기능**: 회사 소개, 제품 전시, 견적 문의 (Web-to-Lead), 고객 센터 (Web-to-Case)
- **기술 스택**: FastAPI, Jinja2, Uvicorn, Salesforce, ngrok
- **특징**: 반응형 웹 디자인, CRM 자동 연동

[📖 자세히 보기 →](./Pre/README.md)

---

### 3. [🤖 coinbot](./coinbot)
**업비트 암호화폐 급등 알림 텔레그램 봇**
<br>2025.08<br>
업비트 거래소의 실시간 시세를 모니터링하여 급등하는 코인을 텔레그램으로 알려주는 봇입니다.

- **주요 기능**: 실시간 KRW 마켓 모니터링, 급등 감지 알고리즘, 텔레그램 알림, 다중 사용자 지원
- **기술 스택**: Python, python-telegram-bot, asyncio, Upbit API
- **특징**: 비동기 처리, API 제한 준수, 실시간 제어

[📖 자세히 보기 →](./coinbot/README.md)

---

### 4. [☁️ multicloud-devsecops](./multicloud-devsecops)
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
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat&logo=javascript&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat&logo=css3&logoColor=white)

### Frameworks & Libraries
- **Backend**: FastAPI, Uvicorn
- **Data Processing**: Pandas, openpyxl
- **Automation**: Selenium, python-telegram-bot, asyncio
- **Infrastructure**: Terraform

### Cloud & DevOps
- **GCP**: Cloud Run, Artifact Registry, Cloud Scheduler, Cloud Build
- **CI/CD**: GitHub Actions
- **Monitoring**: Datadog
- **Containerization**: Docker

### Databases
- **Oracle Cloud Database**
- **GCS (Google Cloud Storage)**

### Integration
- **Salesforce**: Web-to-Lead, Web-to-Case
- **Upbit API**: 암호화폐 시세 조회
- **Telegram Bot API**: 실시간 알림

---

## 📁 디렉토리 구조

```
.
├── Global_in/              # 웹 크롤링 및 카테고리 관리
│   ├── project_crawling/   # 카테고리 데이터 처리
│   └── Sell_Buy/           # (개발 예정)
├── Pre/                    # 유기농 유제품 홈페이지
│   ├── static/             # CSS, JS, 이미지
│   └── templates/          # HTML 템플릿
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
- **웹 개발**: FastAPI 기반 풀스택 웹 애플리케이션
- **데이터 엔지니어링**: 웹 크롤링, 데이터 처리, DB 관리
- **DevOps**: CI/CD 파이프라인, IaC, 클라우드 인프라
- **자동화**: 텔레그램 봇, 스케줄링, 모니터링

### 클라우드 네이티브
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
- **Email**: (이메일 주소 추가)

---

**© 2025 Portfolio Projects**
