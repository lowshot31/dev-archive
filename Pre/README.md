# 🥛 Pre - 유기농 유제품 회사 홈페이지

**FastAPI 기반의 반응형 웹사이트 + Salesforce CRM 연동**

> "유기농, 특별함이 아닌 일상이 되다"

Pre는 유기농 유제품 전문 기업의 공식 홈페이지로, FastAPI와 Salesforce CRM을 연동하여 제품 소개부터 견적 문의, 고객 지원까지 원스톱으로 제공하는 웹 애플리케이션입니다.

---

## 🎯 프로젝트 개요

### 주요 기능

- **회사 소개**: 브랜드 비전, 미션, 연혁(Timeline) 시각화
- **제품 전시**: 동적 필터링 기능을 갖춘 제품 카탈로그
- **견적 문의 (Web-to-Lead)**:
  - 카카오 주소 검색 API 연동
  - 다중 제품 선택 태그 UI
  - 자동 전화번호 포매팅
  - Salesforce Lead 객체 자동 생성
- **고객 센터 (이메일 문의)**:
  - FAQ 아코디언 인터페이스
  - mailto 링크를 통한 이메일 클라이언트 연동
  - 문의 내용 자동 포매팅
- **Experience Cloud 포털 연동**: 로그인 버튼을 통한 고객 포털 접근

### 기술적 특징

✅ **반응형 웹 디자인**: 모바일, 태블릿, 데스크톱 완벽 대응  
✅ **Glassmorphism UI**: 현대적이고 프리미엄한 디자인 시스템  
✅ **실시간 유효성 검사**: 클라이언트 사이드 폼 검증  
✅ **Salesforce 직접 연동**: Web-to-Lead 구현  
✅ **HTTPS 지원**: 로컬 개발 환경에서도 SSL 인증서 적용  
✅ **외부 접속**: ngrok를 통한 터널링 지원

---

## 🛠 기술 스택

### Backend

- **Python 3.x**
- **FastAPI**: 고성능 비동기 웹 프레임워크
- **Uvicorn**: ASGI 서버
- **Jinja2**: 템플릿 엔진

### Frontend

- **HTML5 / CSS3**: 시맨틱 마크업 및 모던 스타일링
- **Vanilla JavaScript (ES6+)**: 프레임워크 없이 순수 JS로 구현
  - Scroll reveal 애니메이션
  - Product filtering engine
  - Form validation & submission
  - Mobile menu toggle

### External APIs & Integration

- **Salesforce**:
  - Web-to-Lead (영업 리드 수집)
  - Experience Cloud (포털 로그인)
- **카카오 우편번호 서비스**: 주소 검색 및 자동 완성
- **Mailto**: 이메일 클라이언트 연동 (고객 센터)

### Development Tools

- **ngrok**: 외부 접속을 위한 터널링
- **SSL Certificates**: 로컬 HTTPS 개발 환경

---

## 📂 프로젝트 구조

```
Pre/
├── app.py                      # FastAPI 메인 애플리케이션 및 라우팅
├── generate_cert.py            # SSL 인증서 생성 스크립트
├── pyproject.toml              # Python 프로젝트 설정
├── PROJECT_DETAIL.md           # 📖 프로젝트 상세 명세서 (기능 및 로직 상세)
├── README.md                   # 이 파일
├── structure.md                # 프로젝트 구조 요약
│
├── static/                     # 정적 자원
│   ├── css/
│   │   └── index.css           # 전역 스타일 & 디자인 시스템
│   ├── js/
│   │   └── main.js             # 전역 UI 인터랙션 핸들러
│   ├── img/                    # 제품 이미지 및 디자인 에셋
│   └── form_source/            # 폼 관련 추가 리소스
│
├── templates/                  # Jinja2 HTML 템플릿
│   ├── base.html               # 공통 레이아웃 (헤더/푸터/네비게이션)
│   ├── index.html              # 메인 홈페이지
│   ├── about.html              # 회사 소개 & 연혁 타임라인
│   ├── products.html           # 제품 목록 & 동적 필터링
│   ├── contact.html            # 견적 문의 (Web-to-Lead + 주소검색)
│   ├── contact_success.html    # 문의 접수 완료 페이지
│   └── support.html            # 고객 센터 (Web-to-Case + FAQ)
│
├── cert.pem                    # SSL 인증서
├── key.pem                     # SSL 개인 키
├── ngrok.exe                   # ngrok 실행 파일
└── ngrok.text                  # ngrok 설정 메모
```

---

## 🚀 실행 방법

### 1️⃣ 의존성 설치

```bash
pip install fastapi uvicorn jinja2 python-multipart
```

### 2️⃣ FastAPI 서버 실행 (HTTPS)

```bash
cd c:\dev_arch\dev-archive\Pre
python -m uvicorn app:app --host 0.0.0.0 --port 8000 --ssl-keyfile key.pem --ssl-certfile cert.pem
```

**로컬 접속**: `https://localhost:8000`

### 3️⃣ 외부 접속 (ngrok) - 선택사항

새 터미널에서:

```bash
cd c:\dev_arch\dev-archive\Pre
.\ngrok http https://localhost:8000
```

ngrok에서 제공하는 `https://xxx.ngrok-free.app` 주소로 외부에서 접속 가능

---

## ⚙️ Salesforce 설정

### Web-to-Lead 설정 (contact.html)

1. Salesforce Setup → Web-to-Lead → Generate 클릭
2. 생성된 HTML 폼에서 `oid` 값 복사
3. `templates/contact.html` 파일 내 다음 부분 수정:

```html
<input type="hidden" name="oid" value="YOUR_ORG_ID" />
<input
  type="hidden"
  name="retURL"
  value="https://your-domain.com/contact/success"
/>
```

### 이메일 문의 설정 (support.html)

`support.html`은 이메일 클라이언트를 통한 문의 방식을 사용합니다.

이메일 수신 주소 변경 시 `templates/support.html` 파일의 444번째 줄 수정:

```javascript
const mailTo = "your-email@example.com"; // sales@pre-dairy.com에서 변경
```

---

## 🎨 디자인 시스템

### 컬러 팔레트

- **Primary Color**: `#2D4A3E` (짙은 숲색 - 신뢰와 자연)
- **Accent Color**: `#B59A7D` (차분한 베이지 - 부드러운 유제품)
- **Background**: `#FAFAFA` (밝은 회색)
- **Text**: `#2C2C2C` (다크 그레이)

### UI 패턴

- **Glassmorphism**: 헤더, 카드 요소에 유리질감 효과
- **Scroll Reveal**: 스크롤 시 요소가 부드럽게 나타나는 애니메이션
- **Responsive Grid**: 모바일 우선 반응형 레이아웃
- **Typography**: `Pretendard`, `Inter` 기반 가독성 높은 폰트

---

## 📋 주요 페이지 상세

### 1. 홈페이지 (`index.html`)

- **Hero Section**: 브랜드 슬로건 및 CTA 버튼
- **Best Sellers**: 인기 제품 3가지 전시
- **Partners**: 주요 파트너십 소개 (학교 급식, 유통사)

### 2. 회사 소개 (`about.html`)

- **비전/미션**: 아이콘 기반 그리드 레이아웃
- **타임라인**: 2010년 설립부터 현재까지 주요 마일스톤
- **파트너십 상세**: 대형 유통사 및 학교 급식 실적

### 3. 제품 (`products.html`)

- **동적 필터링**: 카테고리별 제품 분류 (우유, 치즈, 버터 등)
- **뱃지 시스템**: BEST, NEW 태그
- **제품 카드**: 이미지, 가격, 설명 표시

### 4. 견적 문의 (`contact.html`) ⭐ 핵심 기능

- **카카오 주소 검색**: 우편번호 API 연동
  - 시/도, 시/군/구 자동 분리
  - Salesforce 표준 필드 자동 매핑
- **다중 제품 선택**: 태그 UI로 여러 제품 선택 가능
- **실시간 검증**: 전화번호 포매팅, 필수 필드 체크
- **Web-to-Lead**: Salesforce Lead 객체 자동 생성

### 5. 고객 센터 (`support.html`)

- **FAQ 아코디언**: 자주 묻는 질문 토글
- **문의 접수 폼**: mailto 링크를 통한 이메일 전송
- **자동 포매팅**: 문의 내용이 자동으로 이메일 본문에 작성

---

## 🔧 문제 해결

### 포트 충돌 확인

```bash
netstat -ano | findstr :8000
```

### SSL 인증서 재생성

```bash
python generate_cert.py
```

### ngrok authtoken 설정

```bash
.\ngrok config add-authtoken YOUR_AUTHTOKEN
```

---
### 🔄 System Data Flow Diagram

```mermaid
sequenceDiagram
    participant User as User (Experience Cloud/Web)
    participant SF as Salesforce (LWC/Apex)
    participant API as External Middleware (FastAPI)
    participant Kakao as Kakao Address API

    User->>SF: 주소 입력 요청
    SF->>Kakao: Address Search Request
    Kakao-->>SF: Address Data & Geolocation
    SF->>SF: Apex Logic: Geolocation 기반 대리점 배정
    
    Note over SF, API: 실시간 데이터 동기화
    SF->>API: REST API Callout (Order/Lead Data)
    API-->>API: 외부 DB 연동 및 추가 로직 처리
    API-->>SF: Response (Status: Success/Fail)
    
    SF->>User: 실시간 상태 반영 및 포털 업데이트


## 📖 추가 문서

- **[PROJECT_DETAIL.md](./PROJECT_DETAIL.md)**: 각 페이지의 상세 로직, JavaScript 동작 방식, 폼 엔진 설명
- **[structure.md](./structure.md)**: 프로젝트 파일 구조 간단 요약

---

## 🔗 관련 프로젝트

이 홈페이지는 [**Pre-SFDX**](../Pre-SFDX/) 프로젝트와 연동됩니다:

- **Pre** (이 프로젝트): 프론트엔드 웹사이트
- **Pre-SFDX**: Salesforce CRM 백엔드 및 Experience Cloud 포털

---

## 📞 문의

- **GitHub**: [lowshot31](https://github.com/lowshot31)
- **Email**: lowshot31@gmail.com

---

**© 2025 Pre Dairy Company - Portfolio Project**
